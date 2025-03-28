import { Controller, Get, Post, Body, Patch, Param, Delete, Put, UseGuards, HttpCode, Logger } from '@nestjs/common';
import { AppointmentService } from './appointment.service';
import { CreateAppointmentDto } from './dto/create-appointment.dto';
import { UpdateAppointmentDto } from './dto/update-appointment.dto';
import { AuthGuard } from '@nestjs/passport';

/**
 * Controller for handling appointment-related operations.
 * 
 * This module was developed collaboratively, with contributions from multiple developers.
 * Special thanks to all contributors who helped shape this functionality.
 */
@UseGuards(AuthGuard('jwt'))
@Controller('appointment')
export class AppointmentController {
    private readonly logger = new Logger(AppointmentController.name); // Logger instance

    constructor(private readonly appointmentService: AppointmentService) {}

    /**
     * Endpoint to create a new appointment.
     * @param createAppointmentDto The data for creating a new appointment
     * @returns The created appointment data
     */
    @Post()
    @HttpCode(201) // Explicitly setting the status code for clarity
    async create(@Body() createAppointmentDto: CreateAppointmentDto) {
        this.logger.log(`Creating new appointment with data: ${JSON.stringify(createAppointmentDto)}`);
        try {
            const newAppointment = await this.appointmentService.create(createAppointmentDto);
            this.logger.log(`Appointment created successfully: ${JSON.stringify(newAppointment)}`);
            return newAppointment;
        } catch (error) {
            this.logger.error(`Error creating appointment: ${error.message}`);
            this.logger.error(`Error stack: ${error.stack}`);
            throw error;
        }
    }

    /**
     * Endpoint to fetch all appointments.
     * @returns A list of all appointments
     */
    @Get()
    async findAll() {
        this.logger.log('Fetching all appointments');
        try {
            return await this.appointmentService.findAll();
        } catch (error) {
            this.logger.error(`Error fetching all appointments: ${error.message}`);
            throw error;
        }
    }

    /**
     * Endpoint to fetch appointments for a specific user.
     * @param user_id The ID of the user whose appointments to fetch
     * @returns A list of appointments for the specified user
     */
    @Get('user/:user_id')
    async findByUser(@Param('user_id') user_id: string) {
        this.logger.log(`Fetching appointments for user: ${user_id}`);
        try {
            return await this.appointmentService.findByUser(user_id);
        } catch (error) {
            this.logger.error(`Error fetching appointments for user ${user_id}: ${error.message}`);
            throw error;
        }
    }

    /**
     * Endpoint to fetch a specific appointment by its ID.
     * @param id The ID of the appointment to fetch
     * @returns The appointment data for the given ID
     */
    @Get(':id')
    async findOne(@Param('id') id: string) {
        this.logger.log(`Fetching appointment with ID: ${id}`);
        try {
            return await this.appointmentService.findOne(id);
        } catch (error) {
            this.logger.error(`Error fetching appointment with ID ${id}: ${error.message}`);
            throw error;
        }
    }

    /**
     * Endpoint to update an appointment by its ID.
     * @param id The ID of the appointment to update
     * @param updateAppointmentDto The updated appointment data
     * @returns The updated appointment data
     */
    @Put(':id')
    async update(@Param('id') id: string, @Body() updateAppointmentDto: UpdateAppointmentDto) {
        this.logger.log(`Updating appointment with ID: ${id}`);
        try {
            return await this.appointmentService.update(id, updateAppointmentDto);
        } catch (error) {
            this.logger.error(`Error updating appointment with ID ${id}: ${error.message}`);
            throw error;
        }
    }

    /**
     * Endpoint to delete an appointment by its ID.
     * @param id The ID of the appointment to delete
     * @returns A success message if the appointment is deleted
     */
    @Delete(':id')
    @HttpCode(204) // Explicitly setting the status code for clarity
    async remove(@Param('id') id: string) {
        this.logger.warn(`Deleting appointment with ID: ${id}`);
        try {
            await this.appointmentService.remove(id);
            this.logger.log(`Appointment with ID ${id} deleted successfully`);
        } catch (error) {
            this.logger.error(`Error deleting appointment with ID ${id}: ${error.message}`);
            throw error;
        }
    }
}
