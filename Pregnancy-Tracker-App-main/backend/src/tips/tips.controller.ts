import { Controller, Get, Post, Body, Param, Delete, Put, UseGuards } from '@nestjs/common';
import { TipsService } from './tips.service';
import { CreateTipDto } from './dto/create-tip.dto';
import { AuthGuard } from '@nestjs/passport';
import { Roles } from 'src/auth/roles.decorator';
import { Role } from 'src/auth/roles.enum';

@UseGuards(AuthGuard('jwt'))
@Controller('tips')
export class TipsController {
  constructor(private readonly tipsService: TipsService) {}

  // Create a new tip (Admin only)
  @Roles(Role.Admin)
  @Post()
  async create(@Body() createTipDto: CreateTipDto) {
    return this.tipsService.create(createTipDto);
  }

  // Get all tips
  @Get()
  async findAll() {
    return this.tipsService.findAll();
  }

  // Get tips by type
  @Get('bytype/:type')
  async findByType(@Param('type') type: string) {
    return this.tipsService.findByType(type);
  }

  // Get a specific tip by ID
  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.tipsService.findOne(id);
  }

  // Update an existing tip (Admin only)
  @Roles(Role.Admin)
  @Put(':id')
  async update(@Param('id') id: string, @Body() updateTipDto: CreateTipDto) {
    return this.tipsService.update(id, updateTipDto);
  }

  // Delete a tip (Admin only)
  @Roles(Role.Admin)
  @Delete(':id')
  async remove(@Param('id') id: string) {
    await this.tipsService.remove(id);
    return { success: true };
  }
}
