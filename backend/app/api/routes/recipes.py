from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from ...core.database import get_db
from ...models.recipe import Recipe, Ingredient, RecipeIngredient, Favorite, Rating
from ...schemas.recipe import RecipeOut, RecipeCreate
from ...services.ai_engine import ai_recommend, suggest_missing

router = APIRouter(prefix="/recipes", tags=["Recipes"])


@router.get("/", response_model=List[RecipeOut])
def get_recipes(
    skip: int = 0,
    limit: int = 20,
    is_traditional: Optional[bool] = None,
    difficulty: Optional[str] = None,
    db: Session = Depends(get_db)
):
    try:
        query = db.query(Recipe)
        if is_traditional is not None:
            query = query.filter(Recipe.is_traditional == is_traditional)
        if difficulty:
            query = query.filter(Recipe.difficulty == difficulty)
        return query.offset(skip).limit(limit).all()
    except Exception as e:
        print(f"Error fetching recipes: {e}")
        return []  # return empty list


@router.get("/{recipe_id}", response_model=RecipeOut)
def get_recipe(recipe_id: int, db: Session = Depends(get_db)):
    recipe = db.query(Recipe).filter(Recipe.id == recipe_id).first()
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    return recipe


@router.post("/search")
def search_by_ingredients(
        ingredients: List[str],
        lang: str = "ar",
        db: Session = Depends(get_db)
):
    # looking for recipes by ingredients
    results = []
    all_recipes = db.query(Recipe).all()

    for recipe in all_recipes:
        recipe_ingredients = []
        for ri in recipe.ingredients:
            name = ri.ingredient.name_ar if lang == "ar" else ri.ingredient.name_en
            recipe_ingredients.append(name.lower())

        # Calculating the matching percentage
        matched = sum(
            1 for ing in ingredients
            if any(ing.lower() in r for r in recipe_ingredients)
        )

        if matched > 0:
            results.append({
                "recipe": recipe,
                "match_count": matched,
                "match_percent": round((matched / len(recipe_ingredients)) * 100)
                if recipe_ingredients else 0
            })

    # Sort by percentage of match
    results.sort(key=lambda x: x["match_percent"], reverse=True)
    return results[:10]


@router.post("/rate/{recipe_id}")
def rate_recipe(
        recipe_id: int,
        score: int,
        user_id: int,
        db: Session = Depends(get_db)
):
    if score < 1 or score > 5:
        raise HTTPException(status_code=400, detail="Score must be between 1 and 5")

    existing = db.query(Rating).filter(
        Rating.user_id == user_id,
        Rating.recipe_id == recipe_id
    ).first()

    if existing:
        existing.score = score
    else:
        db.add(Rating(user_id=user_id, recipe_id=recipe_id, score=score))

    db.commit()

    # Average rating update
    ratings = db.query(Rating).filter(Rating.recipe_id == recipe_id).all()
    recipe = db.query(Recipe).filter(Recipe.id == recipe_id).first()
    recipe.rating = sum(r.score for r in ratings) / len(ratings)
    recipe.rating_count = len(ratings)
    db.commit()

    return {"message": "Rated successfully", "new_rating": recipe.rating}

