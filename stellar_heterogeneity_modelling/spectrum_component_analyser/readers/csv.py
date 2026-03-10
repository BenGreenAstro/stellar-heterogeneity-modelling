import pandas as pd

# Load the data - assuming no header row
# If you have headers, remove 'names' and 'header' arguments
df = pd.read_csv('your_file.csv', names=['wavelength', 'flux'], header=None)

# Access the columns
wavelengths = df['wavelength']
fluxes = df['flux']

print(df.head())