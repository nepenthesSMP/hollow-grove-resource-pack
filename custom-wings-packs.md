Make a resource pack folder that kind of mirrors fantastic wings structure; e.g., this is how it would look if we baked the wings into the fantastic wings mod

```
mkdir -p custom-wings/assets/fantasticwings/textures/entity/equipment/wings/
```

in the wings directory add the custom wing files

in the top of the resource pack, add `pack.mcmeta`:
```
{
  "pack": {
    "pack_format": 97,
    "description": "Custom wings textures"
  }
}
```

pack format should be 97 (119 is a data pack).

do the same for the data pack that will live on the server
```
mkdir -p data/fantasticwings/fantasticwings/wings/
```

here, every player should have a json file that looks like:

`nepenthes_b.json`
```
{
  "asset_id": "fantasticwings:nepenthes_b",
  "model": "insectoid"
}
```
etc.

once made, zip the data pack and upload it to `world/datapacks`
```
cd custom-wings-data/
zip -r -X ../custom-wings-data.zip pack.mcmeta data -x "*.DS_Store"
# to confirm
unzip -l custom-wings-data.zip
```

IDK what the format is for windows, and it should be similar in linux; but this ensures mac file clutter doesnt exist... silly mac

The same process needs done for the custom-wings-resource directory as well

```
cd custom-wings-resource/
zip -r -X ../custom-wings-resource.zip pack.mcmeta assets -x "*.DS_Store"
# to confirm
cd ../ && unzip -l custom-wings-resource.zip
```

# NOTE ON THE ARMOR PROPERTIES


custom-wings-resource.zip goes into the players directory or setup a resource pack prompt... custom-wings-data goes server side in the server data pack

redirected the shell script to put it into a *-host/ directory.

check shasum of the zipped file using 

`shasum custom_wings_host/custom-wings-resource.zip`

add the address and shasum to the server propeties and restart the server


