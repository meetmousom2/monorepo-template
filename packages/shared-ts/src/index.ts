/**
 * Shared TypeScript utilities and constants.
 * Import in frontend apps: import { APP_NAME } from "@repo/shared-ts";
 */

export const APP_NAME = "My App";

export type PaginationParams = {
  pageSize: number;
  pageToken?: string;
};

export type PaginatedResponse<T> = {
  items: T[];
  nextPageToken?: string;
};
