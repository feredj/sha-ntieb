from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from ...core.database import get_db
from ...core.security import hash_password, verify_password, create_access_token
from ...models.user import User
from ...schemas.user import UserCreate, UserLogin, Token

router = APIRouter(prefix="/auth", tags=["Auth"])

@router.post("/register", response_model=Token)
def register(data: UserCreate, db: Session = Depends(get_db)):
    # تحقق من البريد
    if db.query(User).filter(User.email == data.email).first():
        raise HTTPException(status_code=400, detail="Email already exists")
    # تحقق من اسم المستخدم
    if db.query(User).filter(User.username == data.username).first():
        raise HTTPException(status_code=400, detail="Username already exists")
    try:
        hashed = hash_password(data.password)
        user = User(
            username=data.username,
            email=data.email,
            hashed_password=hashed
        )
        db.add(user)
        db.commit()
        db.refresh(user)
        token = create_access_token({
            "sub": str(user.id),
            "is_admin": user.is_admin
        })
        return {"access_token": token, "user": user}
    except Exception as e:
        db.rollback()
        print(f"Register error: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/login", response_model=Token)
def login(data: UserLogin, db: Session = Depends(get_db)):
    try:
        user = db.query(User).filter(User.email == data.email).first()
        if not user:
            raise HTTPException(status_code=401, detail="Invalid credentials")
        if not verify_password(data.password, user.hashed_password):
            raise HTTPException(status_code=401, detail="Invalid credentials")
        token = create_access_token({
            "sub": str(user.id),
            "is_admin": user.is_admin
        })
        return {"access_token": token, "user": user}
    except HTTPException:
        raise
    except Exception as e:
        print(f"Login error: {e}")
        raise HTTPException(status_code=500, detail=str(e))