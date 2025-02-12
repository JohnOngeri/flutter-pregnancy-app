import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ExpressAdapter } from '@nestjs/platform-express';
import * as express from 'express';

const corsOptions = {
  origin: '*', // Allow requests from all origins
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
 allowedHeaders: 'Content-Type, Authorization, Accept, Accept-Language, Accept-Encoding'// Allow all headers
};

async function bootstrap() {
  const server = express();
  server.use(express.json({ limit: '50mb' }));
  server.use(express.urlencoded({ limit: '50mb', extended: true }));

  const app = await NestFactory.create(AppModule, new ExpressAdapter(server));
  app.enableCors(corsOptions); // Pass the corsOptions object here
  await app.listen(3000);

  // change
}
bootstrap();