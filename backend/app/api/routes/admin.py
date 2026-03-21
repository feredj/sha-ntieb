from fastapi import APIRouter, Depends, UploadFile, File, HTTPException
from sqlalchemy.orm import Session
import pandas as pd
import io
from ...core.database import get_db
from ...models.recipe import Recipe, Ingredient, RecipeIngredient
from ...schemas.recipe import RecipeCreate, RecipeOut

router = APIRouter(prefix="/admin", tags=["Admin"])

@router.post("/recipes", response_model=RecipeOut)
def create_recipe(data: RecipeCreate, db: Session = Depends(get_db)):
    recipe = Recipe(
        name_ar=data.name_ar,
        name_en=data.name_en,
        description_ar=data.description_ar,
        description_en=data.description_en,
        preparation_ar=data.preparation_ar,
        preparation_en=data.preparation_en,
        is_traditional=data.is_traditional,
        prep_time=data.prep_time,
        difficulty=data.difficulty,
        image_url=data.image_url
    )
    db.add(recipe)
    db.commit()
    db.refresh(recipe)
    return recipe

@router.put("/recipes/{recipe_id}")
def update_recipe(recipe_id: int, data: RecipeCreate, db: Session = Depends(get_db)):
    recipe = db.query(Recipe).filter(Recipe.id == recipe_id).first()
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    for key, value in data.dict(exclude_unset=True).items():
        if key != "ingredients":
            setattr(recipe, key, value)
    db.commit()
    db.refresh(recipe)
    return recipe

@router.post("/import-csv")
async def import_csv(file: UploadFile = File(...), db: Session = Depends(get_db)):
    content = await file.read()

    for encoding in ['utf-8-sig', 'utf-8', 'latin-1', 'cp1256']:
        try:
            text = content.decode(encoding)
            break
        except:
            continue

    text = text.lstrip('\ufeff')

    df = pd.read_csv(
        io.StringIO(text),
        sep=None,
        engine='python',
        skipinitialspace=True,
        on_bad_lines='skip'
    )
    df.columns = df.columns.str.strip().str.lstrip('\ufeff')

    imported = 0
    for _, row in df.iterrows():
        recipe = Recipe(
            name_ar=str(row.get("name_ar", "")),
            name_en=str(row.get("name_en", "")),
            description_ar=str(row.get("description_ar", "")),
            description_en=str(row.get("description_en", "")),
            preparation_ar=str(row.get("preparation_ar", "")),
            preparation_en=str(row.get("preparation_en", "")),
            is_traditional=str(row.get("is_traditional", "false")).lower() in ["true", "1"],
            prep_time=int(float(str(row.get("prep_time", 0) or 0).replace('nan', '0'))),
            difficulty=str(row.get("difficulty", "medium")),
            image_url=str(row.get("image_url", "")) or None
        )
        db.add(recipe)
        db.flush()



        ings_ar = str(row.get("ingredients_ar", "")).split(",")
        ings_en = str(row.get("ingredients_en", "")).split(",")
        quantities = str(row.get("quantities", "")).split(",")
        units = str(row.get("units", "")).split(",")
        categories = str(row.get("categories", "")).split(",")

        for i, (ar, en) in enumerate(zip(ings_ar, ings_en)):
            ar, en = ar.strip(), en.strip()
            if not ar or ar == "nan":
                continue
            qty = quantities[i].strip() if i < len(quantities) else ""
            unit = units[i].strip() if i < len(units) else ""
            category = categories[i].strip() if i < len(categories) else ""

            ingredient = db.query(Ingredient).filter(
                Ingredient.name_ar == ar
            ).first()
            if not ingredient:
                ingredient = Ingredient(name_ar=ar, name_en=en, category=category)
                db.add(ingredient)
                db.flush()
            db.add(RecipeIngredient(
                recipe_id=recipe.id,
                ingredient_id=ingredient.id,
                quantity=qty,
                unit=unit
            ))
        imported += 1

    db.commit()
    return {"message": f" تم استيراد {imported} وصفة بنجاح!"}

@router.delete("/recipes/{recipe_id}")
def delete_recipe(recipe_id: int, db: Session = Depends(get_db)):
    recipe = db.query(Recipe).filter(Recipe.id == recipe_id).first()
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    db.delete(recipe)
    db.commit()
    return {"message": "Deleted successfully"}