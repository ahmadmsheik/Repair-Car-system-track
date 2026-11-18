<?php

namespace App\Http\Controllers;

use App\Models\Client;
use App\Models\Expenditure;
use App\Models\Part;
use App\Models\Task;
use App\Models\Vehicle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class BackupController extends Controller
{
    /**
     * Backup all data (tasks, vehicles, clients).
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function backupData(Request $request)
    {
        // Validate the incoming request
        $request->validate([
            'clients' => 'nullable|array',
            'clients.*.name' => 'required|string',
            'clients.*.phone' => 'required|integer',

            'vehicles' => 'nullable|array',
            'vehicles.*.make' => 'required|string',
            'vehicles.*.model' => 'required|string',
            'vehicles.*.year' => 'required|integer',
            'vehicles.*.vin' => 'required|string',
            'vehicles.*.plate_number' => 'required|integer',
            'vehicles.*.engine_type' => 'nullable|string',
            'vehicles.*.mileage' => 'nullable|integer',
            'vehicles.*.client_id' => 'nullable|integer',

            'tasks' => 'nullable|array',
            'tasks.*.name' => 'required|string',
            'tasks.*.details' => 'nullable|string',
            'tasks.*.status' => 'nullable|string',
            'tasks.*.start_time' => 'nullable|date',
            'tasks.*.end_time' => 'nullable|date',
            'tasks.*.cost' => 'nullable|numeric',
            'tasks.*.current_mileage' => 'nullable|integer',
            'tasks.*.vehicle_id' => 'nullable|integer',

            'parts' => 'nullable|array',
            'parts.*.name' => 'required|string',
            'parts.*.supplier' => 'required|string',
            'parts.*.price' => 'required|numeric',
            'parts.*.task_id' => 'required|integer|exists:tasks,id',

            'expenditures' => 'nullable|array',
            'expenditures.*.name' => 'required|string',
            'expenditures.*.expense_type' => 'required|string',
            'expenditures.*.amount' => 'required|numeric',
            'expenditures.*.due_date' => 'nullable|string',
            'expenditures.*.description' => 'nullable|string',
        ]);

        // Start a database transaction
        DB::beginTransaction();

        try {
            // Drop all existing data from the tables
            DB::table('parts')->delete();
            DB::table('expenditures')->delete();
            DB::table('tasks')->delete();
            DB::table('vehicles')->delete();
            DB::table('clients')->delete();


            if ($request->has('clients')) {
                foreach ($request->clients as $clientData) {
                    Client::create($clientData);
                }
            }


            if ($request->has('vehicles')) {
                foreach ($request->vehicles as $vehicleData) {
                    Vehicle::create($vehicleData);
                }
            }


            if ($request->has('tasks')) {
                foreach ($request->tasks as $taskData) {
                    Task::create($taskData);
                }
            }

            if ($request->has('parts')) {
                foreach ($request->parts as $partData) {
                    Part::create($partData);
                }
            }


            if ($request->has('expenditures')) {
                foreach ($request->expenditures as $expenditureData) {
                    Expenditure::create($expenditureData);
                }
            }


            DB::commit();

            return response()->json([
                'message' => 'Data backed up successfully',
            ], 200);
        } catch (\Exception $e) {

            DB::rollBack();

            return response()->json([
                'message' => 'Backup failed',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Send specific data to the Flutter app.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function sendData(Request $request)
    {
        $tasks = Task::with('vehicle.client')->get();
        $vehicles = Vehicle::with('client')->get();
        $clients = Client::all();
        $expenditures = Expenditure::all();
        $parts = Part::all();


        $data = [
            'tasks' => $tasks,
            'vehicles' => $vehicles,
            'clients' => $clients,
            'expenditures'=> $expenditures,
            'parts'=> $parts
        ];

        return response()->json([
            'message' => 'Data backup successful',
            'data' => $data,
        ], 200);
    }
}
