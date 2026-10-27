# 3/A Dijital Derslik — ücretsiz kurulum
Öğretmen: Murat Bolatlı
Kurum: Özel Süleymaniye Okulları Seyrice İlkokulu

## Durum
GitHub Pages: anonim ve kişisel veri içermeyen tanıtım sitesi.
Supabase: bağlantı bekleniyor. Gerçek öğrenci hesapları HENÜZ yoktur.
Şema: supabase/schema.sql (henüz uygulanmadı).

## Sıfır ücret ilkesi
Supabase Free kotasında kal; ödeme yöntemi, ücretli yükseltme ve ücretli video API'si etkinleştirme.
Servislerin gelecekte fiyat/sınır değiştirebileceğini göz önünde bulundur.

## Güvenli kurulum sırası
1. Supabase hesabını bağla ve Free projeyi seç/oluştur.
2. SQL şemasını gözden geçir, RLS aktif şekilde uygula.
3. Güvenilir yönetim ortamında ilk öğretmen auth hesabı ve profiles(role='teacher') kaydı oluştur.
4. Öğrenci hesaplarını sunucu tarafı yönetici işlemiyle oluştur; örnek şifre kullanma.
5. Yetkilendirme testleri: Öğrenci yalnızca kendi profilini ve ilerlemesini görmeli; başkasının kaydını okuyamamalı.
6. Tarayıcıya yalnızca publishable/anon key koy; service_role/secret key asla koyma.
7. Puanlamayı sunucuda doğrula ve yayımdan önce fotoğraf/veli izinlerini al.
8. Uygulamayı GitHub Pages'e bağla, cihazlar arası senkronizasyonu test et.

## İçerik/video
Animasyon ve tarayıcı seslendirmesi ücretli API gerektirmez. MP4 için herkese açık yetkili depolama veya güvenli dosya dağıtım katmanı gerekir. Otomatik üretken video servisleri ücretsiz garanti edilemez.
