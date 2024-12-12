import numpy as np
import matplotlib.pyplot as plt

# Number of points
num_points = 200

# Generate data
x = np.random.randn(num_points)
y = np.random.randn(num_points)

# Rotation of points1
theta = np.pi / 4

# Definition of rotation matrix
rotation_matrix = np.array([
    [np.cos(theta), -np.sin(theta)],
    [np.sin(theta), np.cos(theta)]
])

# Combining data into points1
points1 = np.dot(rotation_matrix, np.array([x, y * 2]))

# Create random angle for circle
circle_angle = 2 * np.pi * x

# Create random radius for circle
r = y

# Creating hole in data with radius 0.8
while np.any(r < 0.8):
    r[r < 0.8] = np.sqrt(np.random.rand(np.sum(r < 0.8)))

# Combining data into points2
points2 = np.array([r * np.cos(circle_angle), r * np.sin(circle_angle)])

# Covariance matrix
covMatrix1 = np.cov(points1)
covMatrix2 = np.cov(points2)
print('Covariance Matrix points1:')
print(covMatrix1)
print('Covariance Matrix points2:')
print(covMatrix2)

# Correlation matrix
corrMatrix1 = np.corrcoef(points1)
corrMatrix2 = np.corrcoef(points2)
print('Correlation Matrix points1:')
print(corrMatrix1)
print('Correlation Matrix points2:')
print(corrMatrix2)

# Compute eigenvalues and eigenvectors for points1
eigenvalues1, eigenvectors1 = np.linalg.eig(covMatrix1)
print('Eigenvalues points1:')
print(eigenvalues1)
print('Eigenvectors points1:')
print(eigenvectors1)

# Compute eigenvalues and eigenvectors for points2
eigenvalues2, eigenvectors2 = np.linalg.eig(covMatrix2)
print('Eigenvalues points2:')
print(eigenvalues2)
print('Eigenvectors points2:')
print(eigenvectors2)

# Sort eigenvalues and corresponding eigenvectors for points1
indices1 = np.argsort(eigenvalues1)[::-1]
eigenvalues_sorted1 = eigenvalues1[indices1]
eigvecsort1 = eigenvectors1[:, indices1]
print('Sorted Eigenvalues points1:')
print(eigenvalues_sorted1)
print('Sorted Eigenvectors points1:')
print(eigvecsort1)

# Sort eigenvalues and corresponding eigenvectors for points2
indices2 = np.argsort(eigenvalues2)[::-1]
eigenvalues_sorted2 = eigenvalues2[indices2]
eigvecsort2 = eigenvectors2[:, indices2]
print('Sorted Eigenvalues points2:')
print(eigenvalues_sorted2)
print('Sorted Eigenvectors points2:')
print(eigvecsort2)

# Check if the first principal component contains at least 70% of the information for points1
info_pc1_points1 = eigenvalues_sorted1[0] / sum(eigenvalues_sorted1)
print(f'Information in the first principal component for points1: {info_pc1_points1 * 100:.2f}%')

# Check if the transformation effect is minimal for points2 (difference not more than 10%)
info_pc1_points2 = eigenvalues_sorted2[0] / sum(eigenvalues_sorted2)
info_pc2_points2 = eigenvalues_sorted2[1] / sum(eigenvalues_sorted2)
diff_info_points2 = abs(info_pc1_points2 - info_pc2_points2)
print(f'Difference in information between principal components for points2: {diff_info_points2 * 100:.2f}%')

# Plot points1
plt.figure(1)
plt.scatter(points1[0, :], points1[1, :], c='b', marker='o')
plt.title('Points1')
plt.xlabel('x')
plt.ylabel('y')

# Plot the principal axes for points1
mean_points1 = np.mean(points1, axis=1)
for i in range(len(eigvecsort1)):
    plt.quiver(mean_points1[0], mean_points1[1], eigvecsort1[0, i] * eigenvalues_sorted1[i], eigvecsort1[1, i] * eigenvalues_sorted1[i], angles='xy', scale_units='xy', scale=0.5, color='r', linewidth=2)

plt.grid(True)
plt.axis('equal')

# Plot points2
plt.figure(2)
plt.scatter(points2[0, :], points2[1, :], c='b', marker='o')
plt.title('Points2')
plt.xlabel('x')
plt.ylabel('y')

# Plot the principal axes for points2
mean_points2 = np.mean(points2, axis=1)
for i in range(len(eigvecsort2)):
    plt.quiver(mean_points2[0], mean_points2[1], eigvecsort2[0, i] * eigenvalues_sorted2[i], eigvecsort2[1, i] * eigenvalues_sorted2[i], angles='xy', scale_units='xy', scale=0.5, color='r', linewidth=2)

plt.grid(True)
plt.axis('equal')

plt.show()