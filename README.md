# Catmull-Clark Subdivision Visualization

This project is a Catmull-Clark subdivision visualization tool implemented in Processing with the ControlP5 library. It allows users to interactively explore and visualize the subdivision of various 3D geometric shapes using the Catmull-Clark subdivision algorithm.

## Features

- **Interactive Controls:** The user interface provides sliders for controlling the number of iterations of subdivision and the size of the geometric shape.
- **Shape Selection:** Choose from a variety of geometric shapes, including Cube, Pyramid, Tetrahedron, Octahedron, and Icosahedron.
- **Color Options:** Toggle between default and custom color modes. In custom mode, a color wheel is available to choose a custom color for the subdivided faces.
- **Real-time Visualization:** Observe the real-time visualization of the 3D mesh as it undergoes subdivision.

## Getting Started

To run the project, follow these steps:

1. Install Processing (https://processing.org/download/).
2. Open the project in the Processing IDE.
3. Run the sketch by clicking the "Run" button.

## User Interface

- **Number of Iterations Slider:** Adjust the number of iterations for the subdivision.
- **Size Slider:** Control the size of the geometric shape.
- **Shape Selection Radio Buttons:** Choose the base geometric shape for subdivision.
- **Color Mode Radio Buttons:** Switch between default and custom color modes.
- **Color Wheel:** If in custom color mode, use the color wheel to select a custom color for the subdivided faces.

## Catmull-Clark Subdivision Algorithm

The algorithm iteratively subdivides each face of the mesh, creating new vertices and faces based on specific rules. The result is a smoother and more refined 3D mesh. The full algorithm details are provided in the code comments for the people who want to port it in an another language.

## Examples of Geometric Shapes
This program contains 5 shapes:
- **Cube:** A six-faced cube with equal dimensions.
- **Pyramid:** A four-sided pyramid with a square base.
- **Tetrahedron:** A four-faced pyramid with a triangular base.
- **Octahedron:** An eight-faced polyhedron with triangular faces.
- **Icosahedron:** A polyhedron with twenty equilateral triangle faces.

## Interaction

- **Mouse Drag:** Rotate the 3D view by dragging the mouse.

Feel free to explore and experiment with different settings to observe the dynamic subdivision of 3D geometric shapes.
