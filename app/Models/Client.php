<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Client extends Model
{

    use HasFactory;

    public $incrementing = false; 
    protected $keyType = 'integer'; 

    protected $fillable = [
        'id',
        'name',
        'phone',
    ];
    public function vehicles()
    {
        return $this->hasMany(Vehicle::class);
    }
}
