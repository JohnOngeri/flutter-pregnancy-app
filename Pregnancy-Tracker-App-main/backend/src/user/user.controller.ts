import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards, Logger } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from 'src/auth/roles.decorator';
import { Role } from 'src/auth/roles.enum';
import { RolesGuard } from 'src/auth/role.guard';

/**
 * Controller for handling user-related operations.
 * 
 * This controller was developed collaboratively, with contributions from multiple developers.
 * Special thanks to all contributors who helped shape this functionality.
 */
@UseGuards(AuthGuard('jwt'))
@Controller('user')
export class UserController {
    private readonly logger = new Logger(UserController.name); // Logger instance

    constructor(private readonly userService: UserService) {}

    /**
     * Endpoint to create a new user.
     * @param createUserDto The user data for creating a new user
     * @returns The created user data
     */
    @Post()
    async create(@Body() createUserDto: CreateUserDto) {
        this.logger.log(`Starting to create a new user with data: ${JSON.stringify(createUserDto)}`);
        try {
            const newUser = await this.userService.create(createUserDto);
            this.logger.log(`User created successfully: ${JSON.stringify(newUser)}`);
            return newUser;
        } catch (error) {
            this.logger.error(`Error creating user: ${error.message}`);
            this.logger.error(`Error stack: ${error.stack}`);
            throw error;
        }
    }

    /**
     * Endpoint to fetch all users (restricted to Admin role).
     * @returns A list of all users
     */
    @Roles(Role.Admin)
    @UseGuards(RolesGuard)
    @Get()
    async findAll() {
        this.logger.log('Fetching all users');
        try {
            return await this.userService.findAll();
        } catch (error) {
            this.logger.error(`Error fetching all users: ${error.message}`);
            throw error;
        }
    }

    /**
     * Endpoint to fetch a specific user by ID.
     * @param id The ID of the user to fetch
     * @returns The user data for the given ID
     */
    @Get(':id')
    async findOne(@Param('id') id: string) {
        this.logger.log(`Fetching user with ID: ${id}`);
        try {
            return await this.userService.findOne(id);
        } catch (error) {
            this.logger.error(`Error fetching user with ID ${id}: ${error.message}`);
            throw error;
        }
    }

    /**
     * Endpoint to update an existing user by ID.
     * @param id The ID of the user to update
     * @param updateUserDto The updated user data
     * @returns The updated user data
     */
    @Patch(':id')
    async update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
        this.logger.log(`Updating user with ID: ${id}`);
        try {
            return await this.userService.update(id, updateUserDto);
        } catch (error) {
            this.logger.error(`Error updating user with ID ${id}: ${error.message}`);
            throw error;
        }
    }

    /**
     * Endpoint to delete a user by username.
     * @param username The username of the user to delete
     * @returns A success message if the user is deleted
     */
    @Delete(':username')
    async remove(@Param('username') username: string): Promise<any> {
        this.logger.warn(`Deleting user with username: ${username}`);
        try {
            const result = await this.userService.remove(username);
            this.logger.log(`User with username ${username} deleted successfully`);
            return result;
        } catch (error) {
            this.logger.error(`Error deleting user with username ${username}: ${error.message}`);
            throw error;
        }
    }
}
