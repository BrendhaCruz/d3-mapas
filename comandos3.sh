




./node_modules/.bin/ndjson-map 'd[0].properties = {registro: Number(d[1].V003.replace(",", "."))}, d[0]' < pb-registro.ndjson > pb-ortho-comdado.ndjson

#instala o topojason
#npm install topojson

./node_modules/.bin/geo2topo -n tracts=pb-ortho-comdado.ndjson > pb-tracts-topo.json

./node_modules/.bin/toposimplify -p 1 -f < pb-tracts-topo.json | ./node_modules/.bin/topoquantize 1e5 > pb-quantized-topo.json

#instala o d3
#npm install d3

#instala o d3 cores
#npm install d3-scale-chromatic

./node_modules/.bin/topo2geo tracts=- < pb-quantized-topo.json | ./node_modules/.bin/ndjson-map -r d3 'z = d3.scaleSequential(d3.interpolateViridis).domain([0, 12]), d.features.forEach(f => f.properties.fill = z(f.properties.registro)), d' | ./node_modules/.bin/ndjson-split 'd.features' | ./node_modules/.bin/geo2svg -n --stroke none -w 1000 -h 600 > pb-tracts-threshold-light7.svg
