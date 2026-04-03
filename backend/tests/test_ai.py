import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from app.services.ai_engine import (
    normalize,
    simple_match_score,
    tfidf_similarity
)

# =====  normalize =====
def test_normalize_arabic():
    assert normalize("أحمد") == "احمد"
    assert normalize("إسلام") == "اسلام"

def test_normalize_english():
    assert normalize("Carrots") == "carrots"

# =====  simple_match_score =====
def test_match_100_percent():
    user   = ["جزر", "بطاطس"]
    recipe = ["جزر", "بطاطس"]
    result = simple_match_score(user, recipe)
    assert result["match_percent"] == 100

def test_match_50_percent():
    user   = ["جزر"]
    recipe = ["جزر", "بطاطس"]
    result = simple_match_score(user, recipe)
    assert result["match_percent"] == 50

def test_match_zero():
    user   = ["موز"]
    recipe = ["جزر", "بطاطس"]
    result = simple_match_score(user, recipe)
    assert result["match_percent"] == 0

def test_missing_ingredients():
    user   = ["جزر"]
    recipe = ["جزر", "بطاطس", "لحم"]
    result = simple_match_score(user, recipe)
    assert "بطاطس" in result["missing_ingredients"]
    assert "لحم"   in result["missing_ingredients"]

# =====  tfidf =====
def test_tfidf_similar():
    score = tfidf_similarity(
        ["جزر", "بطاطس"],
        ["جزر", "بطاطس", "لحم"]
    )
    assert score > 0.5

def test_tfidf_zero():
    score = tfidf_similarity(
        ["موز"],
        ["جزر", "بطاطس"]
    )
    assert score == 0.0