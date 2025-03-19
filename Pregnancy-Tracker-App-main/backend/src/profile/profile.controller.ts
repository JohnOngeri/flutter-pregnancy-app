import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards, Logger } from '@nestjs/common';
import { ProfileService } from './profile.service';
import { ProfileDto } from './dto/profile.dto';
import { AuthGuard } from '@nestjs/passport';
import { Req } from '@nestjs/common';
import { Request } from 'express';
@UseGuards(AuthGuard('jwt'))
@Controller('profile')
export class ProfileController {
    private readonly logger = new Logger(ProfileController.name); // Logger instance

    constructor(private readonly profileService: ProfileService) { }

    @Get()
    async findAll() {
        this.logger.log(`Fetching all profiles`);
        return await this.profileService.findAll();
    }

    @Get('user/:userName')
    async findByUser(@Param('userName') userName: string) {
        this.logger.log(`Fetching profile by userName: ${userName}`);
        return await this.profileService.findByUser(userName);
    }

    @Get(':id?')
async findOne(@Param('id') id: string, @Req() req: Request) {
    const user = req.user as any; // Cast the user object to any
    const profileId = user.profileId;  // ✅ Correct extraction

    if (!profileId) {
        this.logger.warn(`No authenticated profile ID found. Request failed.`);
        return { message: "Unauthorized: Profile ID not found" };
    }

    this.logger.log(`Fetching profile with ID: ${profileId}`);

    try {
        const profile = await this.profileService.findOne(profileId);
        if (!profile) {
            this.logger.warn(`Profile with ID ${profileId} not found`);
            return { message: "Profile not found", profileId };
        }
        this.logger.log(`Profile found: ${JSON.stringify(profile)}`);
        return profile;
    } catch (error) {
        this.logger.error(`Error fetching profile with ID ${profileId}: ${error.message}`);
        throw error;
    }
}

    


@Post()
async createProfile(@Body() profileDto: ProfileDto) {
    this.logger.log(`[DEBUG] Starting to create a new profile with data: ${JSON.stringify(profileDto)}`);
    
    try {
        const createdProfile = await this.profileService.create(profileDto);
        this.logger.log(`[DEBUG] Profile created successfully: ${JSON.stringify(createdProfile)}`);
        return createdProfile;
    } catch (error) {
        this.logger.error(`[DEBUG] Error creating profile: ${error.message}`);
        this.logger.error(`[DEBUG] Stack trace: ${error.stack}`);
        throw error;
    }
}

@Put(':id?')  // '?' makes ':id' optional
async update(@Req() req: Request, @Body() updateProfileDto: ProfileDto) {
    const user = req.user as any;  // Extract the authenticated user
    const profileId = user.profileId;  // ✅ Always use the JWT profileId

    this.logger.log(`[DEBUG] Updating profile with ID from JWT: ${profileId}`);

    try {
        const updatedProfile = await this.profileService.updateProfile(profileId, updateProfileDto);
        if (!updatedProfile) {
            this.logger.warn(`[DEBUG] Profile with ID ${profileId} not found`);
            return { message: "Profile not found", profileId };
        }

        this.logger.log(`[DEBUG] Profile updated successfully: ${JSON.stringify(updatedProfile)}`);
        return updatedProfile;
    } catch (error) {
        this.logger.error(`[DEBUG] Error updating profile ${profileId}: ${error.message}`);
        this.logger.error(`[DEBUG] Stack trace: ${error.stack}`);
        throw error;
    }
}


@Delete(':id')
async remove(@Param('id') id: string) {
    this.logger.warn(`[DEBUG] Starting to delete profile with ID: ${id}`);
    
    try {
        await this.profileService.removeProfile(id);
        this.logger.log(`[DEBUG] Profile ${id} deleted successfully`);
        return { success: true };
    } catch (error) {
        this.logger.error(`[DEBUG] Error deleting profile ${id}: ${error.message}`);
        this.logger.error(`[DEBUG] Stack trace: ${error.stack}`);
        throw error;
    }
}    
}