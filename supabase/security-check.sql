-- 3/A Dijital Derslik: güvenlik ve kurulum kontrolü
-- Önce supabase/schema.sql çalıştırılmış olmalıdır.
-- Aşağıdaki sorgular salt-okunurdur.
select tablename, rowsecurity
from pg_tables
where schemaname='public' and tablename in ('profiles','lessons','activities','progress')
order by tablename;

select tablename, policyname, cmd, roles
from pg_policies
where schemaname='public' and tablename in ('profiles','lessons','activities','progress')
order by tablename, policyname;

-- Beklenen: dört tabloda rowsecurity = true
-- Beklenen: öğrenci kullanıcıları rol değiştiremez, başka öğrencinin ilerlemesini göremez.
-- DİKKAT: policy görünümü tek başına gerçek kullanıcı testlerinin yerine geçmez.
-- Test için ayrı öğretmen ve test öğrencisi auth hesapları oluşturulmalıdır.
