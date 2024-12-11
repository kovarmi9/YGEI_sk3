import numpy as np
import matplotlib.pyplot as plt

# Number of points
num_points = 200

# Generate first dataset
x1 = np.random.randn(num_points) * 7
y1 = x1 * 0.1 + np.random.randn(num_points)
z1 = x1 * 0.05 + np.random.randn(num_points)

# Combine first 3D dataset
points1 = np.vstack([x1, y1, z1])

# Generate second dataset
x2 = np.random.randn(num_points)
y2 = np.random.randn(num_points)
z2 = np.random.randn(num_points)

# Combine second 3D dataset
points2 = np.vstack([x2, y2, z2])

# Compute the covariance matrix
covMatrix1 = np.cov(points1)
covMatrix2 = np.cov(points2)

# Compute the correlation matrix
corrMatrix1 = np.corrcoef(points1)
corrMatrix2 = np.corrcoef(points2)

# Display covariance and correlation matrices
print('Covariance Matrix (points1):')
print(covMatrix1)
print('Covariance Matrix (points2):')
print(covMatrix2)

print('Correlation Matrix (points2):')
print(corrMatrix1)
print('Correlation Matrix (points2):')
print(corrMatrix2)

# Plot first dataset in 3D
fig1 = plt.figure()
ax1 = fig1.add_subplot(111, projection='3d')
ax1.scatter(points1[0, :], points1[1, :], points1[2, :], c='b', marker='o')
ax1.set_title('Generated 3D Data (points1)')
ax1.set_xlabel('X axis')
ax1.set_ylabel('Y axis')
ax1.set_zlabel('Z axis')

# Plot second dataset in 3D
fig2 = plt.figure()
ax2 = fig2.add_subplot(111, projection='3d')
ax2.scatter(points2[0, :], points2[1, :], points2[2, :], c='r', marker='o')
ax2.set_title('Generated 3D Data (points2)')
ax2.set_xlabel('X axis')
ax2.set_ylabel('Y axis')
ax2.set_zlabel('Z axis')

# Show both plots
plt.show()
