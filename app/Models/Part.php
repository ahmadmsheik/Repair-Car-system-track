<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Part extends Model
{
    protected $fillable = [
        'name',
        'supplier',
        'price',
        'task_id',
    ];
    public function task()
    {
        return $this->belongsTo(Task::class, 'task_id');
    }
}
