// To utilize the default config system built, this file is required. It defines the *structure* of the configuration file. These structured options display as changeable UI elements within the "Config" section of the service details page in the StartOS UI.

// This is where any configuration rules related to the configuration would go. These ensure that the user can only create a valid config.

import { compat } from "../deps.ts";

export const setConfig = compat.setConfig;