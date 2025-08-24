# DataDrip

A Next.js application containerized with Docker for deployment on Railway.

## Docker Setup

This project is containerized and can be deployed to three environments on Railway:
- **Production**: `main` branch → production environment
- **Development**: `development` branch → development environment  
- **Testing**: `test` branch → testing environment

## Local Development with Docker

### Prerequisites
- Docker
- Docker Compose

### Quick Start
1. Clone the repository
2. Build and run with Docker Compose:
   ```bash
   docker-compose up --build
   ```
3. Access the application at `http://localhost:3000`

### Manual Docker Build
```bash
# Build the image
docker build -t datadrip .

# Run the container
docker run -p 3000:3000 datadrip
```

## Railway Deployment

### Automatic Deployment
Each branch automatically deploys to its corresponding environment:
- Push to `main` → deploys to production
- Push to `development` → deploys to development
- Push to `test` → deploys to testing

### Manual Deployment
```bash
# Deploy to Railway
railway up
```

## Docker Configuration

### Multi-stage Build
The Dockerfile uses a multi-stage build process:
1. **deps**: Install production dependencies
2. **builder**: Build the Next.js application
3. **runner**: Create the final production image

### Features
- Node.js 20 Alpine base image for smaller size
- Production-optimized builds
- Security best practices (non-root user)
- Health checks
- Standalone output for optimal containerization

### Environment Variables
- `NODE_ENV`: Set to production in container
- `PORT`: Default 3000
- `NEXT_TELEMETRY_DISABLED`: Disabled for privacy

## Health Check
The application includes a health check endpoint at `/api/health` for container orchestration and monitoring.

## Build Commands
```bash
# Development
npm run dev

# Build for production
npm run build

# Start production server
npm start

# Lint code
npm run lint
```

## Project Structure
```
datadrip/
├── app/                    # Next.js app directory
├── public/                 # Static assets
├── Dockerfile             # Multi-stage Docker build
├── docker-compose.yml     # Local development setup
├── railway.toml          # Railway deployment config
└── .dockerignore         # Docker build exclusions
```
