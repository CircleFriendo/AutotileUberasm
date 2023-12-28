# AutotileUberasm
An autotiling utility to be used with UberASM and Lunar Magic.

<img src="https://github.com/CircleFriendo/AutotileUberasm/assets/131226495/8672fdab-f12d-4fe1-8415-484fa9946e1b" width="400">

This utility allows you to build shapes in Lunar Magic using a single tile and it will merge the tiles in game using the correct edges.

# Map16 Set-Up
The autotiler is set up to process Map16 pages 10-1F (and 30-3F, 50-5F, etc.).
Pick one of those pages and set up your edge pieces in the red area as shown (or use the included Map16 page):

<img src="https://github.com/CircleFriendo/AutotileUberasm/assets/131226495/179cd246-0fbf-49fc-bc14-9e8d86390afc" width="400">

# Usage
Draw your level geometry using the tile in position 00 (e.g. 1000):

<img src="https://github.com/CircleFriendo/AutotileUberasm/assets/131226495/dffe3bb0-9875-4d0d-9c87-4437d92d8a19" width="200">

When the level loads, the autotiler will replace tile 00 with other corresponding tiles on the same Map16 page:

<img src="https://github.com/CircleFriendo/AutotileUberasm/assets/131226495/8b18eb94-5788-413e-96ed-bae521a2316b" width="200">

You can place any other tiles from the same Map16 page without disrupting your shape:

<img src="https://github.com/CircleFriendo/AutotileUberasm/assets/131226495/6e2bf377-90a5-4281-9c43-e8a715e2c96d" width="200">
<img src="https://github.com/CircleFriendo/AutotileUberasm/assets/131226495/d03b48cd-9b69-4d8e-ac60-0d6a87179942" width="200">

# Separate Map16 Pages
You can have separate sets of tiles on different Map16 pages. They will autotile separately:

<img src="https://github.com/CircleFriendo/AutotileUberasm/assets/131226495/8cf5684c-3a71-4505-a95f-2b38263ab959" width="200">
<img src="https://github.com/CircleFriendo/AutotileUberasm/assets/131226495/821341ba-b7b8-432e-8092-ecf8d1661e72" width="200">

# Notes
* Adds some delay to level loads.
* Not configured for vertical level layouts
