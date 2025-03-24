<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_login_success()
    {
        // Buat user untuk testing
        $user = \App\Models\User::factory()->create([
            'email' => 'test@example.com',
            'password' => bcrypt('password'),
        ]);

        // Kirim request login
        $response = $this->postJson('/api/login', [
            'email' => 'test@example.com',
            'password' => 'password',
        ]);

        // Pastikan respons sukses (status code 200) dan memiliki token
        $response->assertStatus(200)
                ->assertJsonStructure(['token']);
    }

    public function test_login_failure()
    {
        $response = $this->postJson('/api/login', [
            'email' => 'wrong@example.com',
            'password' => 'wrongpassword',
        ]);

        // Pastikan respons gagal dengan status code 401
        $response->assertStatus(401)
                ->assertJson([
                    'message' => 'The provided credentials are incorrect.',
                ]);
    }
}