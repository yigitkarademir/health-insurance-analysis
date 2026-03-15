# Sağlık Sigortası Prim Analizi

Portfolyo projesi olarak geliştirdiğim bu çalışmada, 1.337 poliçe sahibinden oluşan bir veri seti üzerinden sağlık sigortası primlerini etkileyen faktörleri inceledim. Amacım yüksek doğruluklu bir tahmin modeli kurmak değil, hangi değişkenlerin sigorta maliyetini ne ölçüde etkilediğini anlamaktı. Bu nedenle yorumlanabilirliği yüksek olan Linear Regression'ı tercih ettim.

---

## Proje Yapısı

Projeyi SQL ve Python olmak üzere iki katmanlı kurdum. SQL tarafında veri kalitesi kontrollerini ve keşifsel analizleri yaptım, Python tarafında ise görselleştirme, modelleme ve tahminlerin tekrar SQL Server'a yazılması işlemlerini gerçekleştirdim.

- **SQL (health_insurance_analysis.sql)** — Veri kalitesi kontrolleri, keşifsel analiz, view oluşturma
- **Python (health_insurance_analysis.ipynb)** — Görselleştirme, özellik mühendisliği, modelleme

---

## Neler Yaptım?

**Veri Hazırlama**
- Eksik değer ve tekrar eden kayıt kontrolü
- Temel istatistikler ve aykırı değer tespiti
- Kategorik değişkenlerin dağılım analizi

**Keşifsel Analiz**
- Prim dağılımı (normal ve log ölçeği) — çarpıklık: 1.52
- Korelasyon matrisi
- Yaş, BMI ve çocuk sayısının prime etkisinin scatter plot ile incelenmesi

**Modelleme**
- Hedef değişkene log dönüşümü uyguladım (sağa çarpık dağılım nedeniyle)
- `sigara × BMI` ve `sigara × yaş` etkileşim terimleri ekledim
- Model öncesi StandardScaler uyguladım

**Risk Segmentasyonu**
SQL ve Python'da tutarlı olacak şekilde poliçe sahiplerini üç gruba ayırdım:
- **Yüksek Risk** — Sigara içenler
- **Orta Risk** — Sigara içmeyen, BMI ≥ 30 olanlar
- **Düşük Risk** — Diğerleri

---

## Ne Buldum?

- Primi en güçlü etkileyen faktör **sigara ile yüksek BMI'nin birleşimidir** (~%95 artış)
- **Yaş** tek başına ikinci en önemli faktör (~%78 artış)
- **BMI tek başına** neredeyse hiç etkili değil — asıl etkisi sigara ile birleşince ortaya çıkıyor
- Bölge ve cinsiyet istatistiksel olarak anlamlı bir fark yaratmıyor

---

## Model Performansı

| Metrik | Değer |
|--------|-------|
| R² Skoru | 0.8709 |

Yüksek tahmin doğruluğu bu projenin önceliği değildi. Asıl hedef her değişkenin prime etkisini sayısal olarak ortaya koymaktı. Tahmin odaklı bir yaklaşım istesem Random Forest + hiperparametre optimizasyonu tercih ederdim.

---

## Kullandığım Araçlar

- **SQL Server** — Veri depolama, sorgulama, view oluşturma
- **Python** — pandas, numpy, matplotlib, seaborn, scikit-learn, sqlalchemy

---

## Veri Seti

1.338 kayıttan oluşuyor, 1 tekrar eden kayıt temizlendi. Değişkenler:
`age`, `sex`, `bmi`, `children`, `smoker`, `region`, `charges`

Kaynak: [Kaggle — Medical Cost Personal Dataset](https://www.kaggle.com/datasets/mirichoi0218/insurance)
