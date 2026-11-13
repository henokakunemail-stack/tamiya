// Mini 4WD Physics Engine & Core Formulas (Ported from common_helper_attrformula.lua)
const PhysicsEngine = {
    calculateStats: function(setup) {
        // Base values
        const motor = setup.motor || { rpm: 22000, torque: 180, weight: 18 };
        const gear = setup.gear || { ratio: 3.5, efficiency: 92, weight: 4 };
        const chassis = setup.chassis || { weight: 42, downforce: 15, stability: 120 };
        const shell = setup.shell || { weight: 16, air_drag: 180, downforce: 45 };
        const tyres = setup.tyres || { grip: 85, rolling_friction: 120, restitution: 45, diameter: 26, weight: 14 };
        const rollers = setup.rollers || { friction: 65, cushion: 75, weight: 8 };
        const damper = setup.damper || { damping: 50, weight: 12 };

        const totalWeight = chassis.weight + shell.weight + motor.weight + gear.weight + tyres.weight + rollers.weight + damper.weight;

        // Formula 1: Speed (km/h)
        // Kecepatan = 15 + (RPM*0.1 + Downforce*0.5 + TransEfficiency*0.01 + (6000 - rollingFriction)*0.005) * 3.5 / gear_ratio
        const rawSpeed = (motor.rpm * 0.0012 + (shell.downforce + chassis.downforce) * 0.05 + (gear.efficiency) * 0.05) * (3.5 / gear.ratio) * (tyres.diameter / 26);
        const topSpeed = Math.round(rawSpeed * 10) / 10;

        // Formula 2: Acceleration (m/s^2)
        // Akselerasi = (Torque*0.1 + (1200 - AirDrag)*0.01 + Grip*0.15) * gear_ratio / 3.5 / (TotalWeight / 100)
        const rawAccel = ((motor.torque * 0.12) + (1200 - shell.air_drag) * 0.01 + (tyres.grip * 0.2)) * (gear.ratio / 3.5) / (totalWeight / 110);
        const accel = Math.round(rawAccel * 10) / 10;

        // Formula 6 & 16: Cornering Stability Index
        // Stabilitas = ChassisStability + RollersCushion*0.8 - RollersFriction*0.4 + TyresGrip*0.5 - (totalWeight * 0.3)
        const corneringStability = Math.round(chassis.stability + (rollers.cushion * 0.8) - (rollers.friction * 0.3) + (tyres.grip * 0.4) - (totalWeight * 0.2));

        // Jump Safety & Downforce
        const totalDownforce = shell.downforce + chassis.downforce;
        const jumpFlightFactor = Math.round((topSpeed * 1.8) / (1 + totalDownforce * 0.02) * 10) / 10; // lower is safer
        const landingStability = Math.round(damper.damping * 1.6 - (tyres.restitution * 0.7) + (totalDownforce * 0.4));

        // Course-Out Risk Index (0 - 100%, lower is safer)
        let riskScore = 0;
        if (topSpeed > 32 && corneringStability < 120) riskScore += (32 - corneringStability) * 1.5;
        if (jumpFlightFactor > 30 && landingStability < 70) riskScore += (jumpFlightFactor - 30) * 2;
        riskScore = Math.max(5, Math.min(95, Math.round(riskScore + (topSpeed * 1.2) - (corneringStability * 0.3))));

        return {
            topSpeed,              // km/h
            acceleration: accel,   // m/s^2
            totalWeight,           // gram
            downforce: totalDownforce,
            corneringStability,
            landingStability,
            gearRatio: gear.ratio,
            riskScore              // 0-100%
        };
    }
};

window.PhysicsEngine = PhysicsEngine;
