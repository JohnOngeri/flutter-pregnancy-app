import { Controller, Get, Post, Body, Param, Delete, Patch, UseGuards, Logger } from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from 'src/auth/roles.decorator';
import { Role } from 'src/auth/roles.enum';
import { RolesGuard } from 'src/auth/role.guard';

@UseGuards(AuthGuard('jwt'))
@Controller('user')
export class UserController {
    private readonly logger = new Logger(UserController.name);

    constructor(private readonly userService: UserService) {}

    // Create a new user
    @Post()
    async create(@Body() createUserDto: CreateUserDto) {
        this.logger.log(`Creating a new user with data: ${JSON.stringify(createUserDto)}`);
        try {
            const newUser = await this.userService.create(createUserDto);
            this.logger.log(`User created successfully: ${JSON.stringify(newUser)}`);
            return newUser;
        } catch (error) {
            this.logger.error(`Error creating user: ${error.message}`);
            this.logger.error(`Stack trace: ${error.stack}`);
            throw error;
        }
    }

    // Fetch all users (Admin only)
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

    // Fetch a specific user by ID
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

    // Update a user by ID
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

    // Delete a user by username
    @Delete(':username')
    async remove(@Param('username') username: string) {
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
