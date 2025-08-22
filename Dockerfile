# Use Node.js LTS (20 in this example)
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock/pnpm-lock.yaml)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy project files
COPY . .

# Build Next.js app
RUN npm run build

# -----------------------------
# Production image
# -----------------------------
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Set env to production
ENV NODE_ENV=production

# Expose port (Railway usually uses 8080 or $PORT)
EXPOSE 8080

# Start Next.js
CMD ["npm", "run", "start", "-p", "8080"]
