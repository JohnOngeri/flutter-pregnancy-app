import { Controller, Get, Post, Put, Delete, Param, Body, UseGuards, Logger, Req } from '@nestjs/common';
import { ProfileService } from './profile.service';
import { ProfileDto } from './dto/profile.dto';
import { AuthGuard } from '@nestjs/passport';
import { Request } from 'express';

/**
 * Controller for managing user profiles.
 * 
 * This controller was developed collaboratively, with contributions from multiple developers.
 * Special thanks to all contributors who helped shape this functionality.
 */
@UseGuards(AuthGuard('jwt'))
@Controller('profile')
export class ProfileController {
    private readonly logger = new Logger(ProfileController.name); // Logger instance

    constructor(private readonly profileService: ProfileService) { }

    /**
     * Endpoint to fetch all profiles.
     * @returns A list of all user profiles
     */
    @Get()
    async findAll() {
        this.logger.log(`Fetching all profiles`);
        try {
            return await this.profileService.findAll();
        } catch (error) {
            this.logger.error(`Error fetching profiles: ${error.message}`);
            throw error;
        }
    }

    /**
     * Endpoint to fetch a profile by username.
     * @param userName The username to fetch the profile for
     * @returns The profile data for the given username
     */
    @Get('user/:userName')
    async findByUser(@Param('userName') userName: string) {
        this.logger.log(`Fetching profile by userName: ${userName}`);
        try {
            return await this.profileService.findByUser(userName);
        } catch (error) {
            this.logger.error(`Error fetching profile for user ${userName}: ${error.message}`);
            throw error;
        }
    }

    /**
     * Endpoint to fetch a profile by profile ID extracted from the JWT.
     * @param id The profile ID (optional)
     * @param req The request object containing JWT data
     * @returns The profile data for the authenticated user
     */
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

    /**
     * Endpoint to create a new profile.
     * @param profileDto The profile data to create a new profile
     * @returns The newly created profile data
     */
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

    /**
     * Endpoint to update an existing profile.
     * @param req The request object containing JWT data
     * @param updateProfileDto The updated profile data
     * @returns The updated profile data
     */
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

    /**
     * Endpoint to delete a profile by its ID.
     * @param id The profile ID to delete
     * @returns A success message if the profile is deleted
     */
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
