export PATH=$PATH:./node_modules/.bin/
#!/bin/bash

# a expressão js que decide os fills baseados em uma escala
# EXP_ESCALA='z = d3.scaleSequential(d3.interpolateViridis).domain([0, 100]),
#             d.features.forEach(f => f.properties.fill = z(f.properties["Percentual Aprendizado Adequado (%)"])),
#             d'
EXP_ESCALA='z = d3.scaleThreshold().domain([-20, -15, -10, -5, 0, 5, 15, 30, 60]).range(d3.schemePRGn[9]),
            d.features.forEach(f => {f.properties.fill = z(f.properties["Crescimento entre 2011 e 2013 (pp*)"]); f.properties.stroke = "#0f0f0f";}),
            d'

ndjson-map -r d3 -r d3=d3-scale-chromatic \
  "$EXP_ESCALA" \
< geo4-municipios-e-aprendizado-simplificado.json \
| ndjson-split 'd.features' \
| geo2svg -n --stroke none -w 1000 -h 600 \
  > aprendizagem-na-pb-choropleth.svg
