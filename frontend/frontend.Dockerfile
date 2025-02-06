# Use a Node.js image to build the frontend
FROM node:18 AS builder

WORKDIR /app

# Copy package.json first to optimize Docker caching
COPY package.json .
RUN npm install

# Copy the rest of the frontend code and build it
COPY . .
RUN npm run build

# Use a lightweight web server for serving the frontend
FROM nginx:alpine

# Copy the built React files to Nginx's serving directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
