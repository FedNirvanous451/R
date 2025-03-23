import pandas as pd
import numpy as np

# Создаем случайные данные
np.random.seed(42)
n_samples = 200

# Генерация BPM (темп музыки)
hip_hop_bpm = np.random.randint(70, 110, size=n_samples // 3)
rock_bpm = np.random.randint(100, 160, size=n_samples // 3)
pop_bpm = np.random.randint(90, 140, size=n_samples // 3 + n_samples % 3)

# Генерация RMS Energy (средняя энергия сигнала)
hip_hop_rms = np.random.uniform(0.1, 0.3, size=n_samples // 3)
rock_rms = np.random.uniform(0.4, 0.8, size=n_samples // 3)
pop_rms = np.random.uniform(0.2, 0.5, size=n_samples // 3 + n_samples % 3)

# Генерация Zero-Crossing Rate (частота пересечения нуля)
hip_hop_zcr = np.random.uniform(0.05, 0.15, size=n_samples // 3)
rock_zcr = np.random.uniform(0.1, 0.3, size=n_samples // 3)
pop_zcr = np.random.uniform(0.08, 0.2, size=n_samples // 3 + n_samples % 3)

# Создаем метки классов
labels = ['хип-хоп'] * (n_samples // 3) + ['рок'] * (n_samples // 3) + ['поп'] * (n_samples // 3 + n_samples % 3)

# Собираем данные в DataFrame
data = pd.DataFrame({
    'BPM': np.concatenate([hip_hop_bpm, rock_bpm, pop_bpm]),
    'RMS Energy': np.concatenate([hip_hop_rms, rock_rms, pop_rms]),
    'Zero-Crossing Rate': np.concatenate([hip_hop_zcr, rock_zcr, pop_zcr]),
    'Жанр': labels
})

# Перемешиваем данные
data = data.sample(frac=1, random_state=42).reset_index(drop=True)

# Сохраняем в CSV (опционально)
data.to_csv('music_genre_dataset.csv', index=False)

# Выводим первые 10 строк
print(data.head(10))