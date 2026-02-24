# Stage 1: Build the frontend React app
FROM node:16-alpine AS frontend-build
WORKDIR /app/frontend

# Copy frontend package.json and install dependencies
COPY frontend/package*.json ./
RUN npm install

# Copy frontend source code and build
COPY frontend/ ./
RUN npm run build

# Stage 2: Setup the backend Node.js server
FROM node:16-alpine
WORKDIR /app

# Copy backend package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the backend source code
COPY backend/ ./backend/
COPY uploads/ ./uploads/

# Copy the built frontend from Stage 1 into the backend's expected directory
COPY --from=frontend-build /app/frontend/build ./frontend/build

# Expose the backend port
EXPOSE 5000

# Set environment variables (Can be overridden at runtime)
ENV NODE_ENV=production
ENV PORT=5000

# Command to run the backend server
CMD ["npm", "run", "server"]