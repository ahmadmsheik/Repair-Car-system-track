<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\BackupController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/backupData', [BackupController::class, 'backupData'])->name('backupData')->middleware('auth:sanctum');
Route::get('/sendData', [BackupController::class, 'sendData'])->name('sendData');

Route::post('/signIn', [AuthController::class, 'signin']);
Route::post('/register', [AuthController::class, 'register']);
Route::post('/logout', [AuthController::class, 'logout']);
