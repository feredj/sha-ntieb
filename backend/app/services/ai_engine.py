import re
import math
from typing import List, Dict, Tuple
from sqlalchemy.orm import Session
from ..models.recipe import Recipe, RecipeIngredient, Ingredient

# ===================================================
# المستوى 1 — تطابق بسيط مع تصحيح إملائي
# ===================================================

def normalize(text: str) -> str:
    """تطبيع النص العربي والإنجليزي"""
    text = text.lower().strip()
    # تطبيع الحروف العربية
    text = re.sub(r'[أإآا]', 'ا', text)
    text = re.sub(r'[ةه]', 'ه', text)
    text = re.sub(r'[يى]', 'ي', text)
    return text

def get_recipe_ingredients(recipe: Recipe, lang: str = 'ar') -> List[str]:
    """استخراج مكونات الوصفة"""
    ingredients = []
    for ri in recipe.ingredients:
        name = ri.ingredient.name_ar if lang == 'ar' else ri.ingredient.name_en
        ingredients.append(normalize(name))
    return ingredients

def simple_match_score(
    user_ingredients: List[str],
    recipe_ingredients: List[str]
) -> Dict:
    """حساب نسبة التطابق البسيط"""
    user_normalized = [normalize(i) for i in user_ingredients]
    matched = []
    missing = []

    for ing in recipe_ingredients:
        found = any(
            u in ing or ing in u or
            # تطابق جزئي (أول 4 أحرف)
            (len(u) >= 4 and len(ing) >= 4 and u[:4] == ing[:4])
            for u in user_normalized
        )
        if found:
            matched.append(ing)
        else:
            missing.append(ing)

    total = len(recipe_ingredients)
    match_count = len(matched)
    match_percent = round((match_count / total * 100)) if total > 0 else 0

    return {
        "match_count": match_count,
        "match_percent": match_percent,
        "matched_ingredients": matched,
        "missing_ingredients": missing,
        "total_ingredients": total,
        "can_make": match_percent >= 70,  # يمكن طبخها إذا 70%+ متوفر
    }


# ===================================================
# المستوى 2 — TF-IDF Cosine Similarity
# ===================================================

def build_tfidf_vector(
    ingredients: List[str],
    all_words: List[str]
) -> List[float]:
    """بناء متجه TF-IDF"""
    tf = {}
    for word in ingredients:
        tf[word] = tf.get(word, 0) + 1

    vector = []
    for word in all_words:
        tf_val = tf.get(word, 0) / len(ingredients) if ingredients else 0
        vector.append(tf_val)

    return vector

def cosine_similarity(vec1: List[float], vec2: List[float]) -> float:
    """حساب التشابه الكوساني"""
    dot = sum(a * b for a, b in zip(vec1, vec2))
    norm1 = math.sqrt(sum(a ** 2 for a in vec1))
    norm2 = math.sqrt(sum(b ** 2 for b in vec2))
    if norm1 == 0 or norm2 == 0:
        return 0.0
    return dot / (norm1 * norm2)

def tfidf_similarity(
    user_ingredients: List[str],
    recipe_ingredients: List[str]
) -> float:
    """حساب التشابه بين مكونات المستخدم والوصفة باستخدام TF-IDF"""
    user_norm   = [normalize(i) for i in user_ingredients]
    recipe_norm = [normalize(i) for i in recipe_ingredients]

    # بناء المفردات المشتركة
    all_words = list(set(user_norm + recipe_norm))
    if not all_words:
        return 0.0

    vec_user   = build_tfidf_vector(user_norm, all_words)
    vec_recipe = build_tfidf_vector(recipe_norm, all_words)

    return cosine_similarity(vec_user, vec_recipe)


# ===================================================
# المستوى 3 — Sentence Transformers (اختياري)
# ===================================================

_model = None

def get_transformer_model():
    """تحميل النموذج مرة واحدة فقط"""
    global _model
    if _model is None:
        try:
            from sentence_transformers import SentenceTransformer
            import numpy as np
            _model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')
            print("✅ AI Model loaded successfully!")
        except Exception as e:
            print(f"⚠️ Transformer not available: {e}")
            _model = "unavailable"
    return _model if _model != "unavailable" else None

def transformer_similarity(
    user_ingredients: List[str],
    recipe_ingredients: List[str]
) -> float:
    """حساب التشابه باستخدام Sentence Transformers"""
    model = get_transformer_model()
    if not model or not user_ingredients or not recipe_ingredients:
        return 0.0
    try:
        import numpy as np
        user_text   = " ".join(user_ingredients)
        recipe_text = " ".join(recipe_ingredients)
        embeddings  = model.encode([user_text, recipe_text])
        similarity  = np.dot(embeddings[0], embeddings[1]) / (
            np.linalg.norm(embeddings[0]) * np.linalg.norm(embeddings[1])
        )
        return float(similarity)
    except Exception:
        return 0.0


# ===================================================
# المحرك الرئيسي — يجمع كل المستويات
# ===================================================

def ai_recommend(
    user_ingredients: List[str],
    db: Session,
    lang: str = 'ar',
    limit: int = 10,
    use_transformer: bool = False
) -> List[Dict]:
    """
    محرك الاقتراح الذكي الرئيسي
    يجمع بين التطابق البسيط + TF-IDF + (اختياري) Transformers
    """
    if not user_ingredients:
        return []

    all_recipes = db.query(Recipe).all()
    results = []

    for recipe in all_recipes:
        recipe_ings = get_recipe_ingredients(recipe, lang)
        if not recipe_ings:
            continue

        # المستوى 1 — تطابق بسيط
        simple = simple_match_score(user_ingredients, recipe_ings)

        # المستوى 2 — TF-IDF
        tfidf_score = tfidf_similarity(user_ingredients, recipe_ings)

        # المستوى 3 — Transformers (إذا مفعّل)
        trans_score = 0.0
        if use_transformer:
            trans_score = transformer_similarity(user_ingredients, recipe_ings)

        # الدرجة النهائية — مزج ذكي
        if use_transformer:
            final_score = (
                simple["match_percent"] * 0.4 +
                tfidf_score * 100 * 0.3 +
                trans_score * 100 * 0.3
            )
        else:
            final_score = (
                simple["match_percent"] * 0.6 +
                tfidf_score * 100 * 0.4
            )

        # فقط نتائج ذات قيمة
        if simple["match_count"] > 0 or tfidf_score > 0.1:
            results.append({
                "recipe": recipe,
                "match_percent":        round(simple["match_percent"]),
                "ai_score":             round(final_score, 1),
                "matched_ingredients":  simple["matched_ingredients"],
                "missing_ingredients":  simple["missing_ingredients"],
                "can_make":             simple["can_make"],
                "tfidf_score":          round(tfidf_score, 3),
                "transformer_score":    round(trans_score, 3),
            })

    # ترتيب بالدرجة النهائية
    results.sort(key=lambda x: x["ai_score"], reverse=True)
    return results[:limit]


# ===================================================
# اقتراح مكونات ناقصة
# ===================================================

def suggest_missing(
    user_ingredients: List[str],
    db: Session,
    lang: str = 'ar'
) -> List[Dict]:
    """اقتراح المكونات الناقصة لإكمال وصفة"""
    recommendations = ai_recommend(user_ingredients, db, lang, limit=5)
    suggestions = []

    for item in recommendations:
        if item["missing_ingredients"]:
            suggestions.append({
                "recipe_name": item["recipe"].name_ar if lang == 'ar' else item["recipe"].name_en,
                "missing": item["missing_ingredients"][:3],  # أهم 3 مكونات ناقصة
                "match_percent": item["match_percent"],
            })

    return suggestions