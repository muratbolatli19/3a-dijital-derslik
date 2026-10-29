# Dijital Derslik — Ortak İçerik ve Etkinlik Standardı (v1)

Bu tasarım **gelecekte 2–10+ okul için yeniden yazmadan kullanılabilecek içerik** üretmeyi amaçlar. Mevcut öğrenciler, oturumlar, puanlar, dersler ve canlı veritabanı şimdilik aynı kalır. Bu belge, çok okullu erişimin **şu an hazır olduğunu iddia etmez**.

## İçerik katmanı
- Her oyuna, konu anlatımına, etkileşimli etkinliğe, teste, PDF'ye ve videoya kalıcı bir `content_id`, `kind`, `subject`, `learning_outcome`, `version` verilir.
- İçeriğin kendisi belirli bir öğretmene, öğrenciye veya okula ait kabul edilmez. Ortak kütüphaneden tekrar kullanılabilir.
- HTML oyunları için erişim yolu manifestte yer alır: `icerik-katalogu.json`. Yeni oyun, listeye yeni kayıt ekleyerek yayınlanabilir.
- Öğrenci adları, fotoğraflar, okul adı, sınıf adı, puanlar **ortak içerik dosyalarına yazılmaz**.
- Oyun arayüzünde tam ekran, dokunmatik kontrol, kişiselleştirilmiş sesli dönüt, erişilebilirlik ve hata/süre puanı standarttır.

## Gelecekteki okul/sınıf ayrımı (henüz uygulanmadı)
1. `schools`: okul kaydı, kimlik.
2. `classes`: okul ile ilişkili sınıf (ör. her okulun kendi 3/A'sı).
3. `class_memberships`: öğrenci-sınıf üyeliği.
4. `teacher_assignments`: öğretmenin yetkili sınıfları.
5. `content_items`: bu manifestten taşınacak ortak içerikler.
6. `content_assignments`: hangi okul/sınıfa hangi içerik yayınlandı.
7. `student_attempts`: öğrenci, içerik, atama, deneme, hatalar, süre ve puan — sunucu doğrulamalı.
8. `school_admin` ve `platform_admin`: birbirinden ayrılmış yönetim yetkileri.

RLS ve Edge Function yetkilendirmesi, her öğrenci denemesini sınıf üyeliğine ve her öğretmen sorgusunu sınıf atamasına bağlamalıdır. Mevcut tek sınıflı sorgular tenant filtresi eklenmeden başka okullara açılmamalıdır. Çocuk verileri ortak kütüphaneye veya başka öğretmenlere açık olmamalıdır.

## Yeni etkinlik paketi biçimi
```json
{
  "content_id": "mat-kesir-model-v1",
  "kind": "interactive_activity",
  "subject": "Matematik",
  "learning_outcome": "MAT.3.1.9",
  "version": 1,
  "config": {"interaction": "drag_drop", "supports_touch": true, "supports_fullscreen": true},
  "publication": {"visibility": "shared", "published": false}
}
```

Bu paket yalnızca içerik tanımıdır; okul-sınıf erişimi ayrı atama kaydıyla yapılır. Yeni oyunlar için mevcut işleyen sayfaları değiştirmeden bu standarda uyulur.

## Geçiş disiplini
- Önce mevcut 3/A yedeği ve rol testi.
- Yeni okul/sınıf tabloları ve şema göçü.
- Gerçek iki farklı öğretmen + öğrenci hesabıyla çapraz erişim/RLS negatif testleri.
- Yalnızca erişim testleri geçerse ikinci okul yayını.
