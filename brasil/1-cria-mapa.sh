export PATH=$PATH:./node_modules/.bin/
#!/bin/bash

# a expressão js que decide os fills baseados em uma escala
# EXP_ESCALA='z = d3.scaleSequential(d3.interpolateViridis).domain([0, 100]),
#             d.features.forEach(f => f.properties.fill = z(f.properties["Percentual Aprendizado Adequado (%)"])),
#             d'
EXP_ESCALA='z = d3.scaleThreshold().domain([0, 30, 70, 100, 150, 200, 300, 400, 500]).range(d3.schemeBlues[9]),
            d.features.forEach(f => {f.properties.fill = z(f.properties["por_ano"]); f.properties.stroke = "#0f0f0f";}),
            d'

ndjson-map -r d3 -r d3=d3-scale-chromatic \
  "$EXP_ESCALA" \
< geo4-municipios-e-computador-simplificado.json \
| ndjson-split 'd.features' \
| geo2svg -n --stroke none -w 1000 -h 600 \
  > computadores-por-aluno-choropleth.svg
