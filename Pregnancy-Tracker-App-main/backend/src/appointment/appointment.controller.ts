import { Controller, Get, Post, Body, Patch, Param, Delete, Put, UseGuards } from '@nestjs/common';
import { AppointmentService } from './appointment.service';
import { CreateAppointmentDto } from './dto/create-appointment.dto';
import { UpdateAppointmentDto } from './dto/update-appointment.dto';
import { AuthGuard } from '@nestjs/passport';

// Protect all routes in this controller using JWT authentication
@UseGuards(AuthGuard('jwt'))
@Controller('appointment')
export class AppointmentController {
  constructor(private readonly appointmentService: AppointmentService) {}

  // Endpoint to create a new appointment
  @Post()
  create(@Body() createAppointmentDto: CreateAppointmentDto) {
    return this.appointmentService.create(createAppointmentDto);
  }

  // Endpoint to fetch all appointments
  @Get()
  findAll() {
    return this.appointmentService.findAll();
  }

  // Endpoint to fetch appointments for a specific user
  @Get('user/:user_id')
  findByUser(@Param('user_id') user_id: string) {
    return this.appointmentService.findByUser(user_id);
  }

  // Endpoint to fetch a specific appointment by its ID
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.appointmentService.findOne(id);
  }

  // Endpoint to update an appointment by ID
  @Put(':id')
  update(@Param('id') id: string, @Body() updateAppointmentDto: UpdateAppointmentDto) {
    return this.appointmentService.update(id, updateAppointmentDto);
  }

  // Endpoint to delete an appointment by ID
  @Delete(':id')
  async remove(@Param('id') id: string) {
    await this.appointmentService.remove(id);
  }
}

