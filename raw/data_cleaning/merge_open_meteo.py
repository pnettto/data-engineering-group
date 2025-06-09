import pandas as pd
import glob
import os
folder_path = r'C:\Users\josep\OneDrive\Desktop\CSVS'
coord_to_city = {
    '55.08N3.59W': 'Dumfries',
    '55.85N4.22W': 'Glasgow',
    '55.92N3.13W': 'Edinburgh',
    '56.49N2.99W': 'Dundee',
    '56.84N5.29W': 'Fort William',
    '57.12N2.10W': 'Aberdeen',
    '57.47N4.24W': 'Inverness',
    '58.24N6.32W': 'Stornoway',
    '60.14N1.26W': 'Lerwick'
}
    city_metadata = {
    'Dumfries': (55.08, -3.59),
    'Glasgow': (55.85, -4.22),
    'Edinburgh': (55.92, -3.13),
    'Dundee': (56.49, -2.99),
    'Fort William': (56.84, -5.29),
    'Aberdeen': (57.12, -2.10),
    'Inverness': (57.47, -4.24),
    'Stornoway': (58.24, -6.32),
    'Lerwick': (60.14, -1.26)
}
csv_files = glob.glob(os.path.join(folder_path, '*.csv'))
all_dfs = []
for file in csv_files:
    filename = os.path.basename(file)
    coord_part = filename.split('-')[-1].replace('.csv', '')
    coord_clean = coord_part[:coord_part.find('W') + 1]
    city = coord_to_city.get(coord_clean, 'Unknown')
    if city != 'Unknown':
        df = pd.read_csv(file, skiprows=[0], usecols=[0, 1, 2])
        df.columns = ['datetime', 'windspeed_10m', 'winddirection_10m']
        df['location'] = city
        df['latitude'] = city_metadata[city][0]
        df['longitude'] = city_metadata[city][1]
        all_dfs.append(df)
        print(f":white_check_mark: Added data for {city}")
    else:
        print(f"Warning: Coordinates {coord_clean} not found in mapping for file {filename}")
if all_dfs:
    merged_df = pd.concat(all_dfs, ignore_index=True)
    merged_df = merged_df.drop(index=0).reset_index(drop=True)
    merged_df = merged_df[~merged_df['windspeed_10m'].str.contains('windspeed_10m', na=False)].reset_index(drop=True)
    merged_df['windspeed_10m'] = pd.to_numeric(merged_df['windspeed_10m'])
    merged_df['winddirection_10m'] = pd.to_numeric(merged_df['winddirection_10m'])
    merged_df['datetime'] = pd.to_datetime(merged_df['datetime'])
    output_path = r'C:\Users\josep\OneDrive\Desktop\scotland_weather_2024_merged_cleaned.csv'
    merged_df.to_csv(output_path, index=False)
    print(f"Cleaned and merged CSV created successfully at {output_path}")
else:
    print("No valid data found to merge.")