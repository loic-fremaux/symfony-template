# Symfony docker template with vitejs
## Setup process

- Verify settings in composer.json like the project name and description
- Move .env.example or .env.prod.example to .env and edit parameters to match your project
- Make sure permission are well-defined for 1000:1000 (`sudo chown 1000:1000 /path/ -R`)
- Start containers with `docker-compose up -d`
- Go into the php container with `docker-compose exec php bash`
- Install libs with `composer install`
- Setup nodejs with `npm install`
- Run either `npm run dev` or `npm run prod`
- Generate application secret key in .env at field `APP_SECRET`
- Enjoy :)

## Utilisation vitejs in symfony

- start services outside the docker container to refresh the page `npm run dev`
- check the variable `VITE_DEV` to 1 for the dev in .env
- For images creates a symbolic link in the public folder `ln -s ../assets/ assets`
- For the production put the variable `VITE_DEV` on 0 
- Delete a symbolic link `rm public/assets -r`
- Start build `npm run build`
- Dependency install `vitejs`, `react vanilla` and `sass`
- Enjoy :)
