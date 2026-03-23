from app.services.ai_engine import (
    normalize,
    simple_match_score,
    tfidf_similarity
)

def test_normalize_arabic():
    assert normalize("أحمد") == "احمد"
    assert normalize("إسلام") == "اسلام"
    assert normalize("آمنة") == "امنه"
    print(" normalize يعمل!")

def test_match_100_percent():
    user   = ["جزر", "بطاطس"]
    recipe = ["جزر", "بطاطس"]
    result = simple_match_score(user, recipe)
    assert result["match_percent"] == 100
    print(" تطابق 100% يعمل!")

def test_match_50_percent():
    user   = ["جزر"]
    recipe = ["جزر", "بطاطس"]
    result = simple_match_score(user, recipe)
    assert result["match_percent"] == 50
    print(" تطابق 50% يعمل!")

def test_match_zero_percent():
    user   = ["موز"]
    recipe = ["جزر", "بطاطس"]
    result = simple_match_score(user, recipe)
    assert result["match_percent"] == 0
    print(" تطابق 0% يعمل!")

def test_missing_ingredients():
    user   = ["جزر"]
    recipe = ["جزر", "بطاطس", "لحم"]
    result = simple_match_score(user, recipe)
    assert "بطاطس" in result["missing_ingredients"]
    assert "لحم"   in result["missing_ingredients"]
    print(" المكونات الناقصة تعمل!")

def test_tfidf_similar():
    score = tfidf_similarity(
        ["جزر", "بطاطس"],
        ["جزر", "بطاطس", "لحم"]
    )
    assert score > 0.5
    print(f" TF-IDF score: {score:.2f}")

def test_tfidf_different():
    score = tfidf_similarity(
        ["موز", "تفاح"],
        ["جزر", "بطاطس", "لحم"]
    )
    assert score == 0.0
    print(" TF-IDF مختلف = 0")