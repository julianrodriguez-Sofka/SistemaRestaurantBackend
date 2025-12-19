// ...existing code...
// SonarQube test: cambio menor para ver interacción en PR

// Código para provocar error de calidad
function unusedFunction() {
  // función vacía
}

// Código duplicado para prueba SonarQube
function duplicatedCode() {
  let x = 10;
  let y = 20;
  let z = x + y;
  return z;
}

function duplicatedCode2() {
  let x = 10;
  let y = 20;
  let z = x + y;
  return z;
}

// Vulnerabilidad: uso de eval
function vulnerableEval(input: string) {
  // SonarQube debe marcar esto como crítico
  return eval(input);
}
import express, { Application } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { errorHandler } from './middlewares/error.middleware';
import authRoutes from './routes/auth.routes';
import userRoutes from './routes/user.routes';
import productRoutes from './routes/product.routes';
import tableRoutes from './routes/table.routes';
import configRoutes from './routes/config.routes';
import orderRoutes from './routes/order.routes';

dotenv.config();

export function createApp(): Application {
  const app = express();

  // Middlewares globales
  app.use(cors());
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));

  // Health check
  app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok', service: 'admin-service' });
  });

  // Rutas
  app.use('/api/auth', authRoutes);
  app.use('/api/users', userRoutes);
  app.use('/api/products', productRoutes);
  app.use('/api/tables', tableRoutes);
  app.use('/api/config', configRoutes);
  app.use('/api/orders', orderRoutes);

  // Middleware de manejo de errores (siempre al final)
  app.use(errorHandler);

  return app;
}