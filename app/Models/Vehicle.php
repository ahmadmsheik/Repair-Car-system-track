<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Vehicle extends Model
{
    use HasFactory;

    public $incrementing = false;
    protected $keyType = 'integer';
    protected $fillable = ['id', 'make', 'model', 'year', 'vin', 'plate_number', 'engine_type', 'image_path', 'mileage', 'client_id'];
    public function client()
    {
        return $this->belongsTo(Client::class, 'client_id');
    }

    public function tasks()
    {
        return $this->hasMany(Task::class);
    }
}
