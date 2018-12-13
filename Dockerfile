###############################################################################
# Step 1 : Builder image
#
FROM node:lts-alpine AS builder

RUN apk update && apk add git

# Define working directory and copy source
WORKDIR /home/node/app
COPY . .
# Install dependencies and build whatever you have to build 
# (babel, grunt, webpack, etc.)
RUN npm install -g yarn && yarn

###############################################################################
# Step 2 : Run image
#
FROM node:lts-alpine
ENV NODE_ENV=production
WORKDIR /home/node/app

# Install deps for production only
COPY ./package* ./
RUN yarn && \
    yarn cache clean --force
# Copy builded source from the upper builder stage
COPY --from=builder /home/node/app/build ./build

# Expose ports (for orchestrators and dynamic reverse proxies)
EXPOSE 3000

# Start the app
CMD yarn run build
