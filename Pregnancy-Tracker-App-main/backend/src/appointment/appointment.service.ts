import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { CreateAppointmentDto } from './dto/create-appointment.dto';
import { UpdateAppointmentDto } from './dto/update-appointment.dto';
import { InjectModel } from '@nestjs/mongoose';
import { Appointment } from './entities/appointment.entity';
import { Model } from 'mongoose';

/**
 * Service for managing appointments.
 * 
 * This service was developed collaboratively, with contributions from various developers.
 * Special thanks to all contributors who enhanced this functionality.
 */
@Injectable()
export class AppointmentService {
  constructor(
    @InjectModel('appointment') private readonly  appointmentModel: Model<Appointment>
  ) {}

  /**
   * Create a new appointment.
   * @param createAppointmentDto The DTO for creating an appointment
   * @returns Created appointment data
   */
  async create(createAppointmentDto: CreateAppointmentDto) {
    try {
      const newAppointment = new this.appointmentModel(createAppointmentDto);
      const result = await newAppointment.save();
      return result;
    } catch (error) {
      // Custom error handling with more specific messages
      throw new HttpException('Error creating appointment: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Find all appointments.
   * @returns Array of all appointments
   */
  async findAll() {
    try {
      return this.appointmentModel.find().exec();
    } catch (error) {
      // Custom error handling with more specific messages
      throw new HttpException('Error retrieving appointments: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Find an appointment by ID.
   * @param id The ID of the appointment
   * @returns The found appointment or null
   */
  async findOne(id: string): Promise<Appointment> {
    try {
      return this.appointmentModel.findById(id).exec();
    } catch (error) {
      // Custom error handling with more specific messages
      throw new HttpException('Error finding appointment: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Find appointments by user.
   * @param author The ID of the user whose appointments to retrieve
   * @returns Array of appointments for the user
   */
  async findByUser(author: string): Promise<Appointment[]> {
    try {
      const finder = { author: author };
      return this.appointmentModel.find(finder).exec();
    } catch (error) {
      // Custom error handling with more specific messages
      throw new HttpException('Error finding user appointments: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Update an appointment.
   * @param id The ID of the appointment to update
   * @param updateAppointmentDto The DTO containing updated appointment data
   * @returns The updated appointment data
   */
  async update(id: string, updateAppointmentDto: UpdateAppointmentDto): Promise<Appointment> {
    try {
      return this.appointmentModel.findByIdAndUpdate(id, updateAppointmentDto, { new: true }).exec();
    } catch (error) {
      // Custom error handling with more specific messages
      throw new HttpException('Error updating appointment: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }

  /**
   * Remove an appointment by ID.
   * @param id The ID of the appointment to remove
   * @returns The result of the removal operation
   */
  async remove(id: string): Promise<any> {
    try {
      return await this.appointmentModel.findByIdAndDelete({ _id: id }).exec();
    } catch (error) {
      // Custom error handling with more specific messages
      throw new HttpException('Error removing appointment: ' + error.message, HttpStatus.BAD_REQUEST);
    }
  }
}
