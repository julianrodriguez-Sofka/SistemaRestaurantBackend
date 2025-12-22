// tests/example.test.ts
import { sum } from '../src/utils/example';

describe('sum', () => {
  it('should add two numbers', () => {
    expect(sum(2, 3)).toBe(5);
  });
});
