<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Expenditure extends Model
{
    protected $fillable = ['name', 'expense_type', 'amount', 'due_date', 'desciption'];
}
