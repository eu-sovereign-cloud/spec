import { configureStore, createSlice } from '@reduxjs/toolkit';

// Create a simple slice (modify as needed)
const counterSlice = createSlice({
  name: 'counter',
  initialState: { value: 0 },
  reducers: {
    increment: (state) => {
      state.value += 1;
    },
  },
});

// Export actions
export const { increment } = counterSlice.actions;

// Create store
const store = configureStore({
  reducer: {
    counter: counterSlice.reducer,
  },
});

export default store;
