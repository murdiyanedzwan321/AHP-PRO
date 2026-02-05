Agro-AHP Pro

Sistem Pendukung Keputusan Perawatan Berbasis Microservices

Dibuat oleh: Murdiyan Edzwan Nazib
Studi Kasus: Pabrik Kopi Roastery

Gambaran Proyek

Agro-AHP Pro adalah sistem pendukung keputusan (Decision Support System) yang dikembangkan menggunakan backend Python (Flask) dan frontend Flutter. Sistem ini menerapkan metode Analytic Hierarchy Process (AHP) untuk menentukan prioritas perawatan mesin berdasarkan kriteria teknis dan ekonomi.

Aplikasi ini dirancang dengan pendekatan microservices, sehingga backend dan frontend dapat berjalan secara independen dan fleksibel, baik secara lokal maupun melalui layanan cloud.

Struktur Repository

/backend
Berisi kode backend Python Flask serta Jupyter Notebook untuk perhitungan AHP.

/frontend
Berisi source code aplikasi mobile Flutter.

Panduan Memulai
1. Setup Backend

Backend berfungsi untuk melakukan perhitungan matriks AHP, eigenvector, dan Consistency Ratio (CR).

Opsi A: Google Colab (Direkomendasikan untuk TOR)

Buka file /backend/Agro_AHP_Engine.ipynb menggunakan Google Colab.

Jalankan seluruh cell notebook.

Salin URL Ngrok yang dihasilkan
(contoh: https://abcd.ngrok-free.app).

Opsi B: Localhost

Install seluruh dependensi:

pip install -r backend/requirements.txt


Jalankan server:

python backend/app.py


Server akan berjalan di:

http://127.0.0.1:5000

2. Konfigurasi Jembatan (GitHub Gist)

Digunakan sebagai penghubung dinamis antara backend dan frontend.

Buat GitHub Gist publik dengan nama config.json.

Isi file dengan format berikut:

{
  "base_url": "URL_NGROK_ANDA"
}


Salin Raw URL dari Gist tersebut.

3. Setup Frontend (Flutter)

Buka file:

frontend/lib/services/ahp_service.dart


Perbarui variabel _configGistUrl dengan Raw URL GitHub Gist.

Catatan: Untuk pengujian lokal, aplikasi otomatis menggunakan fallback localhost:5000.

Jalankan aplikasi:

cd frontend
flutter run

Data Studi Kasus (Pabrik Kopi Roastery)
Kriteria Penilaian

Kestabilan Suhu Sangrai

Konsumsi Gas

Presisi Grinding

Alternatif Mesin

Mesin Roasting A (Jerman)

Mesin Roasting B (China)

Mesin Roasting C (Lokal)

Mesin Roasting D (Second/ Bekas)

Checklist Deliverables

 Backend API (Python / Flask)

 Antarmuka Frontend (Flutter)

 Logika AHP (Eigenvector & Consistency Ratio)

 Implementasi Studi Kasus
