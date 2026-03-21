from pydantic import BaseModel
from typing import Optional, List
from enum import Enum

class DifficultyEnum(str, Enum):
    easy = "easy"
    medium = "medium"
    hard = "hard"

class IngredientBase(BaseModel):
    name_ar: str
    name_en: str
    category: Optional[str] = None

class IngredientOut(IngredientBase):
    id: int
    class Config:
        from_attributes = True

class RecipeIngredientOut(BaseModel):
    quantity: Optional[str]
    unit: Optional[str]
    ingredient: IngredientOut
    class Config:
        from_attributes = True

class RecipeBase(BaseModel):
    name_ar: str
    name_en: str
    description_ar: Optional[str] = None
    description_en: Optional[str] = None
    preparation_ar: str
    preparation_en: str
    is_traditional: bool = False
    prep_time: Optional[int] = None
    difficulty: DifficultyEnum = DifficultyEnum.medium
    image_url: Optional[str] = None

class RecipeCreate(RecipeBase):
    ingredients: List[int] = []

class RecipeOut(RecipeBase):
    id: int
    rating: float
    rating_count: int
    ingredients: List[RecipeIngredientOut] = []
    class Config:
        from_attributes = True