from sqlalchemy import (Column, Integer, String, Boolean,
                        DateTime, Float, Text, Enum, ForeignKey)
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from ..core.database import Base


class Ingredient(Base):
    __tablename__ = "ingredients"

    id = Column(Integer, primary_key=True, index=True)
    name_ar = Column(String(255), nullable=False)
    name_en = Column(String(255), nullable=False)
    category = Column(String(100))


class RecipeIngredient(Base):
    __tablename__ = "recipe_ingredients"

    id = Column(Integer, primary_key=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id", ondelete="CASCADE"))
    ingredient_id = Column(Integer, ForeignKey(
        "ingredients.id", ondelete="CASCADE"))
    quantity = Column(String(100))
    unit = Column(String(50))
    ingredient = relationship("Ingredient")


class Recipe(Base):
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True, index=True)
    name_ar = Column(String(255), nullable=False)
    name_en = Column(String(255), nullable=False)
    description_ar = Column(Text)
    description_en = Column(Text)
    preparation_ar = Column(Text, nullable=False)
    preparation_en = Column(Text, nullable=False)
    is_traditional = Column(Boolean, default=False)
    prep_time = Column(Integer)
    difficulty = Column(Enum("easy", "medium", "hard"), default="medium")
    image_url = Column(String(500))
    rating = Column(Float, default=0)
    rating_count = Column(Integer, default=0)
    created_at = Column(DateTime, server_default=func.now())
    ingredients = relationship("RecipeIngredient", cascade="all, delete")


class Favorite(Base):
    __tablename__ = "favorites"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    recipe_id = Column(Integer, ForeignKey("recipes.id", ondelete="CASCADE"))
    created_at = Column(DateTime, server_default=func.now())


class Rating(Base):
    __tablename__ = "ratings"

    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    recipe_id = Column(Integer, ForeignKey("recipes.id", ondelete="CASCADE"))
    score = Column(Integer)
    created_at = Column(DateTime, server_default=func.now())
