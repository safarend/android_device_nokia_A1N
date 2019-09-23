#
# Copyright 2018 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Get the prebuilt list of APNs
$(call inherit-product, vendor/omni/config/gsm.mk)

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit language packages
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Inherit from our custom product configuration
$(call inherit-product, vendor/omni/config/common.mk)

# Build configuration for a very minimal build
$(call inherit-product, build/target/product/embedded.mk)

# Setup dm-verity configs
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/platform/soc/1da4000.ufshc/by-name/system
$(call inherit-product, build/target/product/verity.mk)

# Storage: for factory reset protection feature
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/platform/soc/1da4000.ufshc/by-name/frp

# Partitions (listed in the file) to be wiped under recovery.
TARGET_RECOVERY_WIPE := \
    device/nokia/A1N/recovery.wipe.common

# ROM fstab
PRODUCT_COPY_FILES += \
  device/nokia/A1N/rootdir/root/fstab.qcom:root/fstab.qcom

# A/B updater
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    system \
    keymaster \
    splash

# A/B OTA packages
PRODUCT_PACKAGES += \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

# A/B OTA dexopt update_engine hookup
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

# The following modules are included in debuggable builds only.
PRODUCT_PACKAGES_DEBUG += \
    bootctl \
    update_engine_client

# Boot control HAL
PRODUCT_PACKAGES += \
    bootctrl.msm8998

PRODUCT_STATIC_BOOT_CONTROL_HAL := \
    bootctrl.msm8998 \
    libgptutils \
    libz

# Statically linked toybox for modprobe in recovery mode
PRODUCT_PACKAGES += \
    toybox_static

# Charger
PRODUCT_PACKAGES += \
    charger_res_images \
    charger

# Define time zone data path
ifneq ($(wildcard bionic/libc/zoneinfo),)
    TZDATAPATH := bionic/libc/zoneinfo
else ifneq ($(wildcard system/timezone),)
    TZDATAPATH := system/timezone/output_data/iana
endif

# Time Zone data for Recovery
ifdef TZDATAPATH
PRODUCT_COPY_FILES += \
$(TZDATAPATH)/tzdata:recovery/root/system/usr/share/zoneinfo/tzdata
endif

PRODUCT_BUILD_PROP_OVERRIDES += \
   PRODUCT_NAME=A1N \
   BUILD_PRODUCT=A1N \
   TARGET_DEVICE=A1N \
   BUILD_FINGERPRINT=Nokia/Avenger_00WW/A1N_sprout:9/PPR1.180610.011/00WW_4_14G:user/release-keys \
   PRIVATE_BUILD_DESC="Avenger_00WW-user 9 PPR1.180610.011 00WW_4_14G release-keys"


PRODUCT_DEVICE := A1N
PRODUCT_NAME := omni_A1N
PRODUCT_BRAND := Nokia
PRODUCT_MODEL := A1N
PRODUCT_MANUFACTURER := Nokia

# Security Patch Hack
PLATFORM_SECURITY_PATCH := 2025-12-31
