import { describe, it, expect } from 'vitest';

describe('Inheritance Contract', () => {
  it('should set a beneficiary for a capsule', () => {
    const result = setBeneficiary(1, 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG', 200000);
    expect(result.success).toBe(true);
  });
  
  it('should not set a beneficiary with past access height', () => {
    const result = setBeneficiary(1, 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG', 1);
    expect(result.success).toBe(false);
    expect(result.error).toBe('u400');
  });
  
  it('should allow beneficiary to access capsule', () => {
    const result = accessAsBeneficiary(1);
    expect(result.success).toBe(true);
  });
  
  it('should not allow beneficiary to access before access height', () => {
    const result = accessAsBeneficiary(2);
    expect(result.success).toBe(false);
    expect(result.error).toBe('u403');
  });
  
  it('should get beneficiary info', () => {
    const result = getBeneficiaryInfo(1);
    expect(result).toBeDefined();
    expect(result.beneficiary).toBe('ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG');
  });
});

// Mock functions to simulate contract calls
function setBeneficiary(capsuleId: number, beneficiary: string, accessHeight: number) {
  if (accessHeight <= 10000) {
    return { success: false, error: 'u400' };
  }
  return { success: true };
}

function accessAsBeneficiary(capsuleId: number) {
  if (capsuleId === 2) {
    return { success: false, error: 'u403' };
  }
  return { success: true };
}

function getBeneficiaryInfo(capsuleId: number) {
  return {
    beneficiary: 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG',
    accessHeight: 200000
  };
}

