


#inicia diretorio mapa
#mkdir mapa-ninja
#cd mapa-ninja

#baixa dados para a construcao espacial do mapa
#curl https://raw.githubusercontent.com/nazareno/intro-d3-mapas/master/dados/pb_setores_censitarios.zip > malha.zip

#unzipa dados
#unzip malha.zip

#instala shapefile
#npm install shapefile

#inicia o shp
./node_modules/.bin/shp2json 25SEE250GC_SIR.shp -o pb.json

#instala a projecao geo
#npm install d3-geo-projection

#inicializa o geo
./node_modules/.bin/geoproject 'd3.geoOrthographic().rotate([54, 14, -2]).fitSize([1000, 600], d)' < pb.json > pb-ortho.json

#dimensoes
./node_modules/.bin/geo2svg -w 1000 -h 600 < pb-ortho.json > pb-ortho.svg

#instala o ndjason
#npm install ndjson-cli

#inicia o ndjason
./node_modules/.bin/ndjson-split 'd.features' < pb-ortho.json > pb-manip.ndjson

#instala o d3-dsv
#npm install d3-dsv

#baixando dados para preencher o mapa
#curl https://raw.githubusercontent.com/nazareno/intro-d3-mapas/master/dados/PB_20171016.zip > dados.zip

#mkdir dados
#unzip dados.zip -d dados
#rm dados.zip

./node_modules/.bin/dsv2json -r ';' -n < "dados/PB/Base informaçoes setores2010 universo PB/CSV/Pessoa10_PB.csv" > pb-censo.ndjson

./node_modules/.bin/dsv2json --input-encoding latin1 -r ';' -n < "dados/PB/Base informaçoes setores2010 universo PB/CSV/Pessoa10_PB.csv" > pb-censo.ndjson

./node_modules/.bin/ndjson-map 'd.Cod_setor = d.properties.CD_GEOCODI, d' < pb-manip.ndjson > pb-ortho-sector.ndjson

./node_modules/.bin/ndjson-join 'd.Cod_setor' pb-ortho-sector.ndjson pb-censo.ndjson > pb-registro.ndjson


./node_modules/.bin/ndjson-map 'd[0].properties = {registro: Number(d[1].V001.replace(",", "."))}, d[0]' < pb-registro.ndjson > pb-ortho-comdado.ndjson

#instala o topojason
#npm install topojson

./node_modules/.bin/geo2topo -n tracts=pb-ortho-comdado.ndjson > pb-tracts-topo.json

./node_modules/.bin/toposimplify -p 1 -f < pb-tracts-topo.json | ./node_modules/.bin/topoquantize 1e5 > pb-quantized-topo.json

#instala o d3
#npm install d3

#instala o d3 cores
#npm install d3-scale-chromatic

./node_modules/.bin/topo2geo tracts=- < pb-quantized-topo.json | ./node_modules/.bin/ndjson-map -r d3 'z = d3.scaleSequential(d3.interpolateViridis).domain([0, 500]), d.features.forEach(f => f.properties.fill = z(f.properties.registro)), d' | ./node_modules/.bin/ndjson-split 'd.features' | ./node_modules/.bin/geo2svg -n --stroke none -w 1000 -h 600 > pb-tracts-threshold-light5.svg
