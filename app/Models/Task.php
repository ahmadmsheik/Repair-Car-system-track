<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Task extends Model
{

    use HasFactory;
    public $incrementing = false; 
    protected $keyType = 'integer';
    protected $fillable = ['id', 'name', 'details', 'status', 'start_time', 'end_time', 'cost', 'vehicle_id'];
    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class, 'vehicle_id');
    }
    public function parts(){
        return $this->hasMany(Part::class);
    }
}
